import SwiftUI

struct DarkModeTransition: ViewModifier {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    func body(content: Content) -> some View {
        content
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isDarkMode)
            .transition(.opacity)
    }
}

extension View {
    func darkModeTransition() -> some View {
        modifier(DarkModeTransition())
    }
} 