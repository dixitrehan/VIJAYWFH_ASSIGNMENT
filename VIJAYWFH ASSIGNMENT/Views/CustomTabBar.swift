import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    let tabs: [TabItem]
    
    var body: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                Spacer()
                TabButton(tab: tab, selectedTab: $selectedTab)
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: -2)
        )
    }
}

struct TabButton: View {
    let tab: TabItem
    @Binding var selectedTab: TabItem
    @Namespace private var namespace
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: selectedTab == tab ? tab.selectedIcon : tab.icon)
                .font(.system(size: 24))
            
            Text(tab.title)
                .font(.caption2)
                .fontWeight(selectedTab == tab ? .bold : .regular)
        }
        .foregroundColor(selectedTab == tab ? .accentColor : .gray)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            ZStack {
                if selectedTab == tab {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.accentColor.opacity(0.2))
                        .matchedGeometryEffect(id: "TAB", in: namespace)
                }
            }
        )
        .onTapGesture {
            withAnimation(.spring()) {
                selectedTab = tab
            }
        }
    }
}

enum TabItem: String, CaseIterable {
    case discover, search, favorites, profile
    
    var title: String {
        switch self {
        case .discover: return "Discover"
        case .search: return "Search"
        case .favorites: return "Favorites"
        case .profile: return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .discover: return "film"
        case .search: return "magnifyingglass"
        case .favorites: return "heart"
        case .profile: return "person"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .discover: return "film.fill"
        case .search: return "magnifyingglass.circle.fill"
        case .favorites: return "heart.fill"
        case .profile: return "person.fill"
        }
    }
} 