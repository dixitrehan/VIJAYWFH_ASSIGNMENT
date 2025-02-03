import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Favorites
    func saveFavorites(_ favorites: Set<Int>) {
        userDefaults.set(Array(favorites), forKey: "favorites")
    }
    
    func loadFavorites() -> Set<Int> {
        Set(userDefaults.array(forKey: "favorites") as? [Int] ?? [])
    }
    
    // MARK: - Cache
    func saveToCache(_ data: Data, forKey key: String) {
        userDefaults.set(data, forKey: key)
    }
    
    func loadFromCache(forKey key: String) -> Data? {
        userDefaults.data(forKey: key)
    }
    
    // MARK: - Settings
    func saveSettings(_ settings: [String: Any]) {
        userDefaults.set(settings, forKey: "appSettings")
    }
    
    func loadSettings() -> [String: Any] {
        userDefaults.dictionary(forKey: "appSettings") ?? [:]
    }
    
    // MARK: - Clear Data
    func clearAllData() {
        let domain = Bundle.main.bundleIdentifier!
        userDefaults.removePersistentDomain(forName: domain)
    }
} 