//
//  ContentView.swift
//  VIJAYWFH ASSIGNMENT
//
//  Created by DIXIT REHAN on 03/02/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MediaViewModel()
    @State private var selectedTab: MediaType = .movies
    @State private var showingSortOptions = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $viewModel.searchText)
                    .padding()
                
                // Media Type Selector
                Picker("Media Type", selection: $selectedTab) {
                    Text("Movies").tag(MediaType.movies)
                    Text("TV Shows").tag(MediaType.tvShows)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Sort Button
                HStack {
                    Text("Sort by: \(viewModel.sortOption.rawValue)")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Button {
                        showingSortOptions = true
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                .padding()
                
                // Media List
                MediaListView(mediaType: selectedTab, viewModel: viewModel)
            }
            .navigationTitle("Discover")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    DarkModeToggle()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: FavoritesView(viewModel: viewModel)) {
                        Image(systemName: "heart.fill")
                    }
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .actionSheet(isPresented: $showingSortOptions) {
            ActionSheet(
                title: Text("Sort by"),
                buttons: MediaViewModel.SortOption.allCases.map { option in
                    .default(Text(option.rawValue)) {
                        viewModel.sortOption = option
                    }
                } + [.cancel()]
            )
        }
    }
}

#Preview {
    ContentView()
}
