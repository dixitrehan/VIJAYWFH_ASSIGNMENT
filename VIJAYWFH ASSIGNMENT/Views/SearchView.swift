import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = MediaViewModel()
    @State private var searchText = ""
    @State private var selectedGenre: Genre?
    @State private var selectedYear: Int?
    @State private var selectedCategories: Set<Category> = []
    @State private var showingFilters = false
    
    let years = Array(1900...2024).reversed()
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding()
                
                // Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        FilterChip(
                            title: selectedGenre?.rawValue ?? "Genre",
                            isSelected: selectedGenre != nil
                        ) {
                            showingFilters = true
                        }
                        
                        if let year = selectedYear {
                            FilterChip(title: "\(year)", isSelected: true) {
                                selectedYear = nil
                            }
                        }
                        
                        ForEach(Array(selectedCategories), id: \.self) { category in
                            FilterChip(title: category.rawValue, isSelected: true) {
                                selectedCategories.remove(category)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Results
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredAndSortedMedia(for: .movies)) { media in
                            NavigationLink(destination: MediaDetailView(media: media)) {
                                MediaRowView(media: media, viewModel: viewModel)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Search")
            .sheet(isPresented: $showingFilters) {
                FilterView(
                    selectedGenre: $selectedGenre,
                    selectedYear: $selectedYear,
                    selectedCategories: $selectedCategories
                )
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.accentColor : Color.secondary.opacity(0.2))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

enum Genre: String, CaseIterable {
    case action = "Action"
    case comedy = "Comedy"
    case drama = "Drama"
    case horror = "Horror"
    case sciFi = "Sci-Fi"
    case thriller = "Thriller"
} 