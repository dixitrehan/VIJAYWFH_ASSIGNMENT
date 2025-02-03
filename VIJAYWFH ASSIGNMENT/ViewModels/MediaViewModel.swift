import Foundation
import Combine

class MediaViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var movies: [Media] = []
    @Published var tvShows: [Media] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var searchText = ""
    @Published var favorites: Set<Int> = Set(UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? [])
    @Published var selectedGenre: String?
    @Published var sortOption: SortOption = .title
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIService
    private let cacheManager: CacheManager
    
    // MARK: - Initialization
    init(apiService: APIService = .shared, cacheManager: CacheManager = .shared) {
        self.apiService = apiService
        self.cacheManager = cacheManager
        setupBindings()
        loadInitialData()
    }
    
    // MARK: - Public Methods
    func refreshData() {
        fetchMedia(forceRefresh: true)
    }
    
    func retry() {
        error = nil
        fetchMedia(forceRefresh: true)
    }
    
    func toggleFavorite(for mediaId: Int) {
        if favorites.contains(mediaId) {
            favorites.remove(mediaId)
        } else {
            favorites.insert(mediaId)
        }
        UserDefaults.standard.set(Array(favorites), forKey: "favorites")
    }
    
    func isFavorite(_ mediaId: Int) -> Bool {
        favorites.contains(mediaId)
    }
    
    func fetchMedia(forceRefresh: Bool = false) {
        guard shouldFetchMedia(forceRefresh) else { return }
        
        isLoading = true
        
        apiService.fetchAllMedia()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] in self?.handleCompletion($0) },
                receiveValue: { [weak self] in self?.handleMediaResponse($0) }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        setupSearchBinding()
    }
    
    private func loadInitialData() {
        loadCachedData()
        fetchMedia()
    }
    
    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.handleSearchQuery(query)
            }
            .store(in: &cancellables)
    }
    
    private func handleSearchQuery(_ query: String) {
        if query.isEmpty {
            loadCachedData()
        } else {
            searchMedia(query: query)
        }
    }
    
    private func loadCachedData() {
        if let cachedData = cacheManager.loadMedia() {
            self.movies = cachedData.movies
            self.tvShows = cachedData.shows
        }
    }
    
    private func searchMedia(query: String) {
        isLoading = true
        
        apiService.searchMedia(query: query)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] media in
                self?.movies = media.filter { $0.type == "movie" }
                self?.tvShows = media.filter { $0.type == "tv_series" }
            }
            .store(in: &cancellables)
    }
    
    private func shouldFetchMedia(_ forceRefresh: Bool) -> Bool {
        forceRefresh || movies.isEmpty || tvShows.isEmpty
    }
    
    private func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        isLoading = false
        if case .failure(let error) = completion {
            self.error = error
        }
    }
    
    private func handleMediaResponse(_ response: (movies: [Media], shows: [Media])) {
        movies = response.movies
        tvShows = response.shows
        cacheManager.saveMedia(movies: movies, shows: tvShows)
    }
    
    func filteredAndSortedMedia(for type: MediaType) -> [Media] {
        let mediaList = type == .movies ? movies : tvShows
        
        let filtered = mediaList.filter { media in
            let matchesSearch = searchText.isEmpty || 
                media.title.localizedCaseInsensitiveContains(searchText)
            let matchesGenre = selectedGenre == nil || 
                (media.genres?.contains(where: { $0.localizedCaseInsensitiveContains(selectedGenre!) }) ?? false)
            return matchesSearch && matchesGenre
        }
        
        return filtered.sorted { first, second in
            switch sortOption {
            case .title:
                return first.title < second.title
            case .releaseDate:
                return (first.releaseDate ?? "") > (second.releaseDate ?? "")
            case .rating:
                return (first.rating ?? 0) > (second.rating ?? 0)
            }
        }
    }
}

// MARK: - Supporting Types
extension MediaViewModel {
    enum SortOption: String, CaseIterable {
        case title = "Title"
        case releaseDate = "Release Date"
        case rating = "Rating"
    }
}

struct MediaResponse: Decodable {
    let titles: [Media]
}

// Add Rating property to Media model
extension Media {
    var rating: Double? {
        // Convert user_rating to Double if available
        if let ratingString = userRating {
            return Double(ratingString)
        }
        return nil
    }
} 
