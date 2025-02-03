import SwiftUI

struct DarkModeToggle: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var isAnimating = false
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isDarkMode.toggle()
                isAnimating = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isAnimating = false
            }
        } label: {
            Image(systemName: isDarkMode ? "sun.max.fill" : "lightbulb.fill")
                .font(.system(size: 20))
                .foregroundColor(isDarkMode ? .yellow : .orange)
                .symbolEffect(.bounce, value: isAnimating)
                .rotationEffect(.degrees(isDarkMode ? 180 : 0))
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
} 