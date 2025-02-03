import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: MediaViewModel
    
    var favoriteMovies: [Media] {
        viewModel.movies.filter { viewModel.isFavorite($0.id) }
    }
    
    var favoriteTVShows: [Media] {
        viewModel.tvShows.filter { viewModel.isFavorite($0.id) }
    }
    
    var body: some View {
        List {
            if !favoriteMovies.isEmpty {
                Section("Movies") {
                    ForEach(favoriteMovies) { media in
                        NavigationLink(destination: MediaDetailView(media: media)) {
                            MediaRowView(media: media, viewModel: viewModel)
                        }
                    }
                }
            }
            
            if !favoriteTVShows.isEmpty {
                Section("TV Shows") {
                    ForEach(favoriteTVShows) { media in
                        NavigationLink(destination: MediaDetailView(media: media)) {
                            MediaRowView(media: media, viewModel: viewModel)
                        }
                    }
                }
            }
            
            if favoriteMovies.isEmpty && favoriteTVShows.isEmpty {
                Text("No favorites yet")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .navigationTitle("Favorites")
    }
} 