import Foundation
@testable import VIJAYWFH_ASSIGNMENT

class MockCacheManager: CacheManager {
    var mockCachedMedia: (movies: [Media], shows: [Media])?
    
    override func loadMedia() -> (movies: [Media], shows: [Media])? {
        return mockCachedMedia
    }
} 