import SwiftUI
import AVKit

// Info Content Panel
struct InfoContentPanel: View {
    let player: AVPlayer
    let videoTitle: String
    let videoDescription: String
    @Binding var isPlaying: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(videoTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(videoDescription)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(3)
                .padding(.bottom, 5)
            
            HStack {
                Text("Thriller")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("•")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("50min")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 15)
            
            // Action buttons row
            HStack(spacing: 20) {
                // From Beginning button
                Button(action: {
                    // Reset playback to beginning
                    player.seek(to: CMTime.zero)
                    player.play()
                    isPlaying = true
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("From Beginning")
                    }
                    .font(.headline)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                
                // Details button
                Button(action: {}) {
                    Text("Details")
                        .font(.headline)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// Insight Content Panel
struct InsightContentPanel: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("ON-SCREEN")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            
            // First cast member info
            CastMemberView(
                name: "Sidse Babett Knudsen",
                role: "Professor Andrea Lavin"
            )
            
            // Second cast member info
            CastMemberView(
                name: "Maanuv Thiara",
                role: "Dr Charan Nathoo"
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

// Cast Member View
struct CastMemberView: View {
    let name: String
    let role: String
    
    var body: some View {
        HStack(spacing: 15) {
            // Profile image
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 70, height: 70)
                .overlay(
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                )
            
            // Name and role
            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(role)
                    .font(.body)
                    .foregroundColor(.gray)
            }
        }
    }
}

// Continue Watching Content Panel
struct ContinueContentPanel: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(0..<5) { index in
                ContinueShowItem(index: index)
                
                if index < 4 {
                    Divider()
                        .background(Color.gray.opacity(0.3))
                        .padding(.vertical, 8)
                }
            }
        }
        .padding(.horizontal, 0)
    }
    
    // Helper function to get show title by index
    private func getTitleForIndex(_ index: Int) -> String {
        let titles = ["Prime Target", "Berlin ER", "Argylle", "Black Bird", "See"]
        return titles[index]
    }
}

// Individual show item for Continue panel
struct ContinueShowItem: View {
    let index: Int
    
    var body: some View {
        HStack(spacing: 15) {
            // Thumbnail
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(UIColor.darkGray))
                .frame(width: 120, height: 70)
            
            // Title and info
            VStack(alignment: .leading, spacing: 4) {
                Text(getTitleForIndex(index))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(getInfoForIndex(index))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Options button
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // Helper function to get show title by index
    private func getTitleForIndex(_ index: Int) -> String {
        let titles = ["Prime Target", "Berlin ER", "Argylle", "Black Bird", "See"]
        return titles[index]
    }

    // Helper function to get show info by index
    private func getInfoForIndex(_ index: Int) -> String {
        switch index {
        case 0:
            return "Next · S1, E2 · Apple TV+"
        case 1:
            return "Continue · S1, E2 · 48 min left · Apple TV+"
        case 2:
            return "Continue · 2 hr 9 min left · Apple TV+"
        case 3:
            return "Continue · S1, E1 · 58 min left · Apple TV+"
        case 4:
            return "Continue · S1, E1 · 55 min left · Apple TV+"
        default:
            return ""
        }
    }
}

// Selection buttons for content panels
struct ContentSelectionButtons: View {
    @Binding var selectedContent: String
    @Binding var showInfoPanel: Bool
    @Binding var infoModeActive: Bool
    
    var body: some View {
        HStack(spacing: 25) {
            // Info button
            ContentSelectionButton(
                title: "Info",
                isSelected: selectedContent == "Info",
                action: {
                    handleButtonAction(for: "Info")
                }
            )
            
            // Insight button
            ContentSelectionButton(
                title: "Insight",
                isSelected: selectedContent == "Insight",
                action: {
                    handleButtonAction(for: "Insight")
                }
            )
            
            // Continue button
            ContentSelectionButton(
                title: "Continue",
                isSelected: selectedContent == "Continue",
                action: {
                    handleButtonAction(for: "Continue")
                }
            )
        }
        .padding(.top, 15)
    }
    
    // Handle button selection and toggling
    private func handleButtonAction(for content: String) {
        if selectedContent == content {
            // If same button is pressed again, exit info mode
            withAnimation {
                showInfoPanel = false
                infoModeActive = false // Return to regular full-screen mode
            }
        } else {
            // Set selected content and ensure panel is shown
            selectedContent = content
            showInfoPanel = true
        }
    }
}

// Individual content selection button
struct ContentSelectionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(isSelected ? .black : .white)
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color.white : Color.clear)
                        .stroke(Color.white, lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
