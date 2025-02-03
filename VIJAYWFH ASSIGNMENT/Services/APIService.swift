import Foundation
import Combine

class APIService {
    static let shared = APIService()
    
    private let baseURL = "https://api.watchmode.com/v1"
    private let apiKey = "YOUR_API_KEY"
    
    func fetchAllMedia() -> AnyPublisher<(movies: [Media], shows: [Media]), Error> {
        Publishers.Zip(
            fetchMedia(type: "movie"),
            fetchMedia(type: "tv_series")
        )
        .map { movies, shows in
            (movies: movies, shows: shows)
        }
        .eraseToAnyPublisher()
    }
    
    func searchMedia(query: String) -> AnyPublisher<[Media], Error> {
        let endpoint = "\(baseURL)/search"
        let params = [
            "apiKey": apiKey,
            "search_field": "name",
            "search_value": query
        ]
        
        return makeRequest(endpoint: endpoint, params: params)
    }
    
     func fetchMedia(type: String) -> AnyPublisher<[Media], Error> {
        let endpoint = "\(baseURL)/list-titles"
        let params = [
            "apiKey": apiKey,
            "types": type,
            "limit": "20"
        ]
        
        return makeRequest(endpoint: endpoint, params: params)
    }
    
    private func makeRequest(endpoint: String, params: [String: String]) -> AnyPublisher<[Media], Error> {
        guard let url = makeURL(endpoint: endpoint, params: params) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MediaResponse.self, decoder: JSONDecoder())
            .map(\.titles)
            .eraseToAnyPublisher()
    }
    
    private func makeURL(endpoint: String, params: [String: String]) -> URL? {
        var components = URLComponents(string: endpoint)
        components?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components?.url
    }
} 
