import Foundation

class CacheManager {
    static let shared = CacheManager()
    
    private let cache = NSCache<NSString, NSArray>()
    private let dataManager = DataManager.shared
    
    func saveMedia(movies: [Media], shows: [Media]) {
        // Memory cache
        cache.setObject(movies as NSArray, forKey: "movies")
        cache.setObject(shows as NSArray, forKey: "tvShows")
        
        // Disk cache
        do {
            let encodedMovies = try JSONEncoder().encode(movies)
            let encodedShows = try JSONEncoder().encode(shows)
            
            dataManager.saveToCache(encodedMovies, forKey: "cachedMovies")
            dataManager.saveToCache(encodedShows, forKey: "cachedTVShows")
        } catch {
            print("Cache error: \(error)")
        }
    }
    
    func loadMedia() -> (movies: [Media], shows: [Media])? {
        // Try memory cache first
        if let cachedMovies = cache.object(forKey: "movies") as? [Media],
           let cachedShows = cache.object(forKey: "tvShows") as? [Media] {
            return (movies: cachedMovies, shows: cachedShows)
        }
        
        // Try disk cache
        if let moviesData = dataManager.loadFromCache(forKey: "cachedMovies"),
           let showsData = dataManager.loadFromCache(forKey: "cachedTVShows"),
           let movies = try? JSONDecoder().decode([Media].self, from: moviesData),
           let shows = try? JSONDecoder().decode([Media].self, from: showsData) {
            
            // Update memory cache
            cache.setObject(movies as NSArray, forKey: "movies")
            cache.setObject(shows as NSArray, forKey: "tvShows")
            
            return (movies: movies, shows: shows)
        }
        
        return nil
    }
} 