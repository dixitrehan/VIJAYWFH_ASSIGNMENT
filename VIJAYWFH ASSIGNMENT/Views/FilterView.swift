import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedGenre: Genre?
    @Binding var selectedYear: Int?
    @Binding var selectedCategories: Set<Category>
    
    let years = Array(1900...2024).reversed()
    
    var body: some View {
        NavigationView {
            List {
                Section("Categories") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Category.allCases, id: \.self) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: selectedCategories.contains(category)
                                ) {
                                    if selectedCategories.contains(category) {
                                        selectedCategories.remove(category)
                                    } else {
                                        selectedCategories.insert(category)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                }
                
                Section("Genre") {
                    ForEach(Genre.allCases, id: \.self) { genre in
                        HStack {
                            Text(genre.rawValue)
                            Spacer()
                            if selectedGenre == genre {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedGenre = genre
                        }
                    }
                }
                
                Section("Release Year") {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 10) {
                            ForEach(years, id: \.self) { year in
                                YearButton(
                                    year: year,
                                    isSelected: selectedYear == year,
                                    action: {
                                        selectedYear = year
                                    }
                                )
                            }
                        }
                        .padding(.vertical)
                    }
                    .frame(height: 200)
                }
                
                Section {
                    Button("Reset Filters") {
                        selectedGenre = nil
                        selectedYear = nil
                        selectedCategories.removeAll()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
}

struct CategoryButton: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 24))
                Text(category.rawValue)
                    .font(.caption)
                    .fontWeight(isSelected ? .bold : .regular)
            }
            .frame(width: 80)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.accentColor : Color.secondary.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(isSelected ? Color.accentColor : Color.clear)
                    )
            )
            .foregroundColor(isSelected ? .white : .primary)
            .animation(.spring(), value: isSelected)
        }
    }
}

struct YearButton: View {
    let year: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(year)")
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .regular)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color.accentColor : Color.secondary.opacity(0.1))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

#Preview {
    FilterView(
        selectedGenre: .constant(.action),
        selectedYear: .constant(2024),
        selectedCategories: .constant([.trending, .topRated])
    )
} 