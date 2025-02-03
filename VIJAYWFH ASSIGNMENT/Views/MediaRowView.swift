import SwiftUI

struct MediaRowView: View {
    let media: Media
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: MediaViewModel
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Poster Image
            AsyncImage(url: URL(string: media.posterURL ?? "")) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .shimmer()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 100, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 5)
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(media.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    FavoriteButton(isSelected: viewModel.isFavorite(media.id)) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            viewModel.toggleFavorite(for: media.id)
                        }
                    }
                }
                
                if let releaseDate = media.releaseDate {
                    Text(formatDate(releaseDate))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text(media.overview)
                    .font(.subheadline)
                    .lineLimit(3)
                    .foregroundColor(.secondary)
                
                // Tags
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        MediaTag(text: media.type.capitalized, color: .blue)
                        if viewModel.isFavorite(media.id) {
                            MediaTag(text: "Favorite", color: .red)
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                .shadow(
                    color: Color.black.opacity(0.1),
                    radius: isHovered ? 10 : 5,
                    x: 0,
                    y: isHovered ? 5 : 2
                )
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
        .contentShape(Rectangle())
        .contextMenu {
            MediaContextMenu(media: media, viewModel: viewModel)
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
}

struct FavoriteButton: View {
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isSelected ? "heart.fill" : "heart")
                .font(.title3)
                .foregroundColor(isSelected ? .red : .gray)
                .symbolEffect(.bounce, value: isSelected)
        }
    }
}

struct MediaTag: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}

struct MediaContextMenu: View {
    let media: Media
    @ObservedObject var viewModel: MediaViewModel
    
    var body: some View {
        Button {
            viewModel.toggleFavorite(for: media.id)
        } label: {
            Label(
                viewModel.isFavorite(media.id) ? "Remove from Favorites" : "Add to Favorites",
                systemImage: viewModel.isFavorite(media.id) ? "heart.slash" : "heart"
            )
        }
        
        Button {
            // Add to watchlist
        } label: {
            Label("Add to Watchlist", systemImage: "bookmark")
        }
        
        Button {
            // Share
        } label: {
            Label("Share", systemImage: "square.and.arrow.up")
        }
    }
}

struct MediaRowView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMedia = try! JSONDecoder().decode(Media.self, from: """
        {
            "id": 1,
            "title": "Sample Movie",
            "poster": "https://example.com/poster.jpg",
            "release_date": "2024-02-03",
            "plot_overview": "Sample overview text",
            "type": "movie"
        }
        """.data(using: .utf8)!)
        
        MediaRowView(media: sampleMedia, viewModel: MediaViewModel())
            .padding()
            .previewLayout(.sizeThatFits)
    }
} 