import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: Int
    @State private var isAtBottom = false
    @EnvironmentObject private var playbackStateManager: PlaybackStateManager
    @State private var showVideoPlayer = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content with scroll view
            ScrollView {
                VStack(spacing: 0) {
                    
                    HeaderView()
                    
                    // Season 2 section
                    SeasonSection()
                    
                    // Bonus Content section
                    BonusContentSection()
                    
                    // Cast & Crew section
                    CastCrewSection()
                        .padding(.bottom, 100)
                    
                    // This GeometryReader detects when we've reached the bottom
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollViewOffsetPreferenceKey.self,
                                       value: geometry.frame(in: .global).minY)
                    }
                    .frame(height: 0)
                }
            }
            .edgesIgnoringSafeArea(.top)
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                // Check if we're near the bottom of the content
                withAnimation(.easeInOut) {
                    isAtBottom = value < 200
                }
            }
            
            // Tab bar at bottom
            TVTabView(selectedTab: $selectedTab, isAtBottom: isAtBottom)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showVideoPlayer) {
            // Present video player as sheet with resume time
            VideoPlayerView(resumeFrom: playbackStateManager.lastPlayedProgress)
        }
    }
    
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant(0))
            .preferredColorScheme(.dark)
    }
}
