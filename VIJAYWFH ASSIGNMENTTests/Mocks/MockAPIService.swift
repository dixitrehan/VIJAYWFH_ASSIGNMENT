import Foundation
import Combine
@testable import VIJAYWFH_ASSIGNMENT

class MockAPIService: APIService {
    var mockResult: Result<(movies: [Media], shows: [Media]), Error>?
    
    override func fetchAllMedia() -> AnyPublisher<(movies: [Media], shows: [Media]), Error> {
        guard let result = mockResult else {
            return Fail(error: NSError(domain: "test", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        
        return result.publisher
            .delay(for: .milliseconds(100), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
} 