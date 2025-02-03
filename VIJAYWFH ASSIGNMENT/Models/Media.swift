import Foundation

struct Media: Identifiable, Codable {
    let id: Int
    let title: String
    let posterURL: String?
    let releaseDate: String?
    let overview: String
    let type: String
    let genres: [String]?
    let userRating: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case posterURL = "poster"
        case releaseDate = "release_date"
        case overview = "plot_overview"
        case type = "type"
        case genres = "genres"
        case userRating = "user_rating"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        posterURL = try container.decodeIfPresent(String.self, forKey: .posterURL)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? "No overview available"
        type = try container.decode(String.self, forKey: .type)
        genres = try container.decodeIfPresent([String].self, forKey: .genres)
        userRating = try container.decodeIfPresent(String.self, forKey: .userRating)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(posterURL, forKey: .posterURL)
        try container.encodeIfPresent(releaseDate, forKey: .releaseDate)
        try container.encode(overview, forKey: .overview)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(genres, forKey: .genres)
        try container.encodeIfPresent(userRating, forKey: .userRating)
    }
}

// Helper computed properties
extension Media {
 
    var formattedGenres: String {
        genres?.joined(separator: ", ") ?? "Not categorized"
    }
    
    var isMovie: Bool {
        type.lowercased() == "movie"
    }
} 
