import Foundation

enum Category: String, CaseIterable {
    case trending = "Trending"
    case topRated = "Top Rated"
    case newReleases = "New Releases"
    case comingSoon = "Coming Soon"
    case classics = "Classics"
    case awardWinning = "Award Winning"
    case familyFriendly = "Family Friendly"
    case indie = "Independent"
    
    var icon: String {
        switch self {
        case .trending: return "chart.line.uptrend.xyaxis"
        case .topRated: return "star.fill"
        case .newReleases: return "sparkles"
        case .comingSoon: return "calendar"
        case .classics: return "film"
        case .awardWinning: return "trophy.fill"
        case .familyFriendly: return "person.2.fill"
        case .indie: return "camera.fill"
        }
    }
} 