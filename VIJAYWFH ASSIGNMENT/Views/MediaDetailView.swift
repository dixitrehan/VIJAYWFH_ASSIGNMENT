import SwiftUI

struct MediaDetailView: View {
    let media: Media
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Poster Image
                AsyncImage(url: URL(string: media.posterURL ?? "")) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.2))
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 400)
                .clipped()
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title and Release Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text(media.title)
                            .font(.title)
                            .bold()
                        
                        if let releaseDate = media.releaseDate {
                            Text("Released: \(formatDate(releaseDate))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Overview
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Overview")
                            .font(.headline)
                        
                        Text(media.overview)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: date)
    }
} 