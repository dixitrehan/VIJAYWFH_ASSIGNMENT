import SwiftUI

struct ProfileView: View {
    @AppStorage("username") private var username = ""
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = true
    
    var body: some View {
        NavigationView {
            List {
                Section("User Profile") {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.accentColor)
                        
                        VStack(alignment: .leading) {
                            TextField("Enter username", text: $username)
                                .font(.headline)
                            Text("Movie Enthusiast")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Preferences") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                    Button("Reset Onboarding") {
                        hasSeenOnboarding = false
                    }
                }
                
                Section("Statistics") {
                    StatisticRow(title: "Favorites", value: "12")
                    StatisticRow(title: "Watched", value: "48")
                    StatisticRow(title: "Watchlist", value: "23")
                }
                
                Section("About") {
                    NavigationLink("App Info") {
                        AppInfoView()
                    }
                    Link("Rate the App", destination: URL(string: "https://apps.apple.com")!)
                    Link("Privacy Policy", destination: URL(string: "https://yourapp.com/privacy")!)
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct StatisticRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(.accentColor)
        }
    }
} 