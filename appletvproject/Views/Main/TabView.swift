import SwiftUI

struct TVTabView: View {
    @Binding var selectedTab: Int
    let isAtBottom: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab bar - Apple TV style
            HStack(spacing: 0) {
                Spacer(minLength: 30)
                
                TabItem(iconName: "house.fill", title: "Home", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                
                
                
                TabItem(iconName: "applelogo", title: "Apple TV+", isSelected: selectedTab == 1) {
                    selectedTab = 0
                }
                
                
                
                TabItem(iconName: "bag", title: "Store", isSelected: selectedTab == 2) {
                    selectedTab = 0
                }
                
                
                
                TabItem(iconName: "square.stack", title: "Library", isSelected: selectedTab == 3) {
                    selectedTab = 0
                }
                
                
                
                TabItem(iconName: "magnifyingglass", title: "Search", isSelected: selectedTab == 4) {
                    selectedTab = 0
                }
                
                Spacer(minLength: 30)
            }
            .padding(.vertical, 15)
            
            
        }
        .background(
            isAtBottom ?
            AnyView(Color(white: 0.3)) :
                AnyView(Color.black.opacity(0.5).background(.ultraThinMaterial))
        )
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TabItem: View {
    let iconName: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: iconName)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .blue : .gray)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .frame(width: 80)
        }
        .buttonStyle(PlainButtonStyle())
        .focusable(true)
    }
}

