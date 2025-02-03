import XCTest
import Combine
@testable import VIJAYWFH_ASSIGNMENT

class MediaViewModelTests: XCTestCase {
    var sut: MediaViewModel!
    var mockAPIService: MockAPIService!
    var mockCacheManager: MockCacheManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        mockCacheManager = MockCacheManager()
        sut = MediaViewModel(apiService: mockAPIService, cacheManager: mockCacheManager)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockAPIService = nil
        mockCacheManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Fetch Tests
    func testFetchMediaSuccess() {
        // Given
        let expectation = expectation(description: "Fetch media success")
        mockAPIService.mockResult = .success((movies: mockMovies, shows: mockTVShows))
        
        // When
        sut.fetchMedia()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.sut.isLoading)
            XCTAssertEqual(self.sut.movies.count, 2)
            XCTAssertEqual(self.sut.tvShows.count, 2)
            XCTAssertNil(self.sut.error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchMediaFailure() {
        // Given
        let expectation = expectation(description: "Fetch media failure")
        let mockError = NSError(domain: "test", code: 0, userInfo: nil)
        mockAPIService.mockResult = .failure(mockError)
        
        // When
        sut.fetchMedia()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(self.sut.isLoading)
            XCTAssertNotNil(self.sut.error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Search Tests
    func testSearchDebounce() {
        // Given
        let expectation = expectation(description: "Search debounce")
        expectation.expectedFulfillmentCount = 1
        var searchCount = 0
        
        // When
        sut.$searchText
            .sink { _ in
                searchCount += 1
            }
            .store(in: &cancellables)
        
        sut.searchText = "a"
        sut.searchText = "av"
        sut.searchText = "ava"
        sut.searchText = "avat"
        sut.searchText = "avata"
        sut.searchText = "avatar"
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(searchCount, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Filter Tests
    func testFilterByGenre() {
        // Given
        sut.movies = mockMovies
        sut.selectedGenre = "Action"
        
        // When
        let filtered = sut.filteredAndSortedMedia(for: .movies)
        
        // Then
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.title, "Avatar")
    }
    
    // MARK: - Sort Tests
    func testSortByTitle() {
        // Given
        sut.movies = mockMovies
        sut.sortOption = .title
        
        // When
        let sorted = sut.filteredAndSortedMedia(for: .movies)
        
        // Then
        XCTAssertEqual(sorted.first?.title, "Avatar")
        XCTAssertEqual(sorted.last?.title, "The Matrix")
    }
    
    // MARK: - Cache Tests
    func testCacheLoading() {
        // Given
        mockCacheManager.mockCachedMedia = (movies: mockMovies, shows: mockTVShows)
        
        // When
        sut.loadInitialData()
        
        // Then
        XCTAssertEqual(sut.movies.count, 2)
        XCTAssertEqual(sut.tvShows.count, 2)
    }
}

// MARK: - Mock Data
extension MediaViewModelTests {
    var mockMovies: [Media] {
        [
            Media(id: 1, title: "Avatar", posterURL: nil, releaseDate: "2009-12-18", overview: "Test", type: "movie", genres: ["Action"], userRating: "8.5"),
            Media(id: 2, title: "The Matrix", posterURL: nil, releaseDate: "1999-03-31", overview: "Test", type: "movie", genres: ["Sci-Fi"], userRating: "8.7")
        ]
    }
    
    var mockTVShows: [Media] {
        [
            Media(id: 3, title: "Breaking Bad", posterURL: nil, releaseDate: "2008-01-20", overview: "Test", type: "tv_series", genres: ["Drama"], userRating: "9.5"),
            Media(id: 4, title: "Game of Thrones", posterURL: nil, releaseDate: "2011-04-17", overview: "Test", type: "tv_series", genres: ["Fantasy"], userRating: "9.3")
        ]
    }
} 