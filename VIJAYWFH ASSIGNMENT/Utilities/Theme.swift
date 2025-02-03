import SwiftUI

struct Theme {
    @AppStorage("isDarkMode") static var isDarkMode = false
    
    static let primary = Color.customPrimary
    static let secondary = Color.customSecondary
    static let accent = Color.customAccent
    static let background = Color.customBackground
    
    static let gradient = LinearGradient(
        colors: [Color.customAccent, Color.customAccent.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.black.opacity(isDarkMode ? 0.3 : 0.0),
            Color.black.opacity(isDarkMode ? 0.7 : 0.5)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
} 