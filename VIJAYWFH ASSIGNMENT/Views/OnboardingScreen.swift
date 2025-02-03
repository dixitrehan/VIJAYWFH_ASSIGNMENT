import SwiftUI

struct OnboardingScreen: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentTab = 0
    
    let onboardingData = [
        OnboardingItem(
            image: "film.fill",
            title: "Discover Movies",
            description: "Explore the latest and greatest movies from around the world"
        ),
        OnboardingItem(
            image: "tv.fill",
            title: "TV Shows",
            description: "Find your next favorite TV series to binge watch"
        ),
        OnboardingItem(
            image: "heart.fill",
            title: "Save Favorites",
            description: "Keep track of what you love by adding them to your favorites"
        ),
        OnboardingItem(
            image: "magnifyingglass",
            title: "Search & Filter",
            description: "Easily find content with powerful search and filtering options"
        )
    ]
    
    var body: some View {
        if hasSeenOnboarding {
            ContentView()
        } else {
            TabView(selection: $currentTab) {
                ForEach(0..<onboardingData.count, id: \.self) { index in
                    OnboardingPage(item: onboardingData[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .overlay(alignment: .bottom) {
                if currentTab == onboardingData.count - 1 {
                    Button {
                        withAnimation {
                            hasSeenOnboarding = true
                        }
                    } label: {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
    }
}

struct OnboardingItem {
    let image: String
    let title: String
    let description: String
}

struct OnboardingPage: View {
    let item: OnboardingItem
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: item.image)
                .font(.system(size: 80))
                .foregroundColor(.accentColor)
                .padding()
            
            Text(item.title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            Text(item.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 32)
            
            Spacer()
        }
        .padding()
    }
} 