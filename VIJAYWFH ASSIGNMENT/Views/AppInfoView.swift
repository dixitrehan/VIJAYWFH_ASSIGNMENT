import SwiftUI

struct AppInfoView: View {
    var body: some View {
        List {
            Section("App Details") {
                InfoRow(title: "Version", value: Bundle.main.appVersion)
                InfoRow(title: "Build", value: Bundle.main.buildNumber)
            }
            
            Section("Credits") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Developed by")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Dixit Rehan")
                        .font(.headline)
                }
                .padding(.vertical, 4)
                
                Link("Visit Website", destination: URL(string: "https://yourwebsite.com")!)
            }
            
            Section("API Credits") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Powered by")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Watchmode API")
                        .font(.headline)
                }
                .padding(.vertical, 4)
                
                Link("API Documentation", destination: URL(string: "https://api.watchmode.com/docs")!)
            }
            
            Section("Legal") {
                NavigationLink("Terms of Service") {
                    LegalTextView(title: "Terms of Service", content: termsOfService)
                }
                
                NavigationLink("Privacy Policy") {
                    LegalTextView(title: "Privacy Policy", content: privacyPolicy)
                }
                
                Text("© 2024 MovieFlix. All rights reserved.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("App Info")
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

struct LegalTextView: View {
    let title: String
    let content: String
    
    var body: some View {
        ScrollView {
            Text(content)
                .font(.body)
                .padding()
        }
        .navigationTitle(title)
    }
}

extension Bundle {
    var appVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}

// Sample legal text
private let termsOfService = """
Terms of Service

1. Acceptance of Terms
By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement.

2. Use License
Permission is granted to temporarily download one copy of the app for personal, non-commercial transitory viewing only.

3. Disclaimer
The materials on MovieFlix's application are provided on an 'as is' basis.
"""

private let privacyPolicy = """
Privacy Policy

1. Information Collection
We collect information that you provide directly to us when using the application.

2. How We Use Your Information
We use the information we collect to operate and improve our app, and to provide the services you've requested.

3. Information Sharing
We do not share your personal information with third parties except as described in this privacy policy.
""" 