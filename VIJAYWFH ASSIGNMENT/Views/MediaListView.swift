import SwiftUI

struct MediaListView: View {
    let mediaType: MediaType
    @ObservedObject var viewModel: MediaViewModel
    @Environment(\.refresh) private var refresh
    
    var body: some View {
        Group {
            if viewModel.isLoading && (viewModel.movies.isEmpty && viewModel.tvShows.isEmpty) {
                LoadingView()
            } else if let error = viewModel.error {
                ErrorView(error: error) {
                    viewModel.retry()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredAndSortedMedia(for: mediaType)) { media in
                            NavigationLink(destination: MediaDetailView(media: media)) {
                                MediaRowView(media: media, viewModel: viewModel)
                            }
                        }
                    }
                    .padding()
                }
                .refreshable { // iOS 15+ pull-to-refresh
                    Task {
                        await handleRefresh()
                    }
                }
            }
        }
    }
    
    @Sendable
    private func handleRefresh() async {
        // Ensure UI updates happen on main thread
        await MainActor.run {
            viewModel.refreshData()
        }
    }
}

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).opacity(0.8))
    }
}

#Preview {
    MediaListView(mediaType: .movies, viewModel: MediaViewModel())
} 