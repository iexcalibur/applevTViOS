import SwiftUI
import AVKit

struct DocumentaryDetailsView: View {
    // Add parameter to determine if this view is part of a button
    var isPartOfButton: Bool = false
        
    // Keep video player state but remove alert state
    @State private var showVideoPlayer = false
        
    // Add a variable to track if we've preloaded the player
    @State private var preloadedPlayer: Bool = false
        
    // Add a focus state for the entire view
    @FocusState private var viewFocused: Bool
        
    // Add reference to the PlaybackStateManager
    @EnvironmentObject private var playbackStateManager:PlaybackStateManager
    
    var body: some View {
        Button(action: {
            print("DocumentaryDetailsView tapped!")
            // Directly show video player without alert
            showVideoPlayer = true
        }) {
            // Wrap the entire content in the button
            VStack(alignment: .leading, spacing: 15) {
                // Title
                Text("Amazing Earth")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                    
             //Metadata
            HStack(spacing: 5) {
                Spacer() // Add spacer at the beginning to push content to center
                
                Text("Documentary")
                    .foregroundColor(.white)
                Text("•")
                    .foregroundColor(.white)
                Text("Jun 27, 2021")
                    .foregroundColor(.white)
                Text("•")
                    .foregroundColor(.white)
                Text("30 min")
                    .foregroundColor(.white)
                Text("TV+")
                    .foregroundColor(.white)
                
                Spacer()
            }
            .font(.system(size: 13))
            .padding(.top, 5)
            
            // Play button - only interactive if this view is not part of a button
            if isPartOfButton {
                // Visual button only (non-interactive)
                HStack {
                    Image(systemName: "play.fill")
                        .font(.system(size: 18))
                    // Update text to show Resume Playing if video was started
                    Text(playbackStateManager.hasStartedPlaying ? "Resume Playing" : "Play S2, E1")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.vertical, 10)
            } else {
                // Interactive button when DocumentaryDetailsView is used standalone
                Button(action: {
                    print("Button tapped!")
                    // Directly show video player without alert
                    showVideoPlayer = true
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                            .font(.system(size: 18))
                        // Update text to show Resume Playing if video was started
                        Text(playbackStateManager.hasStartedPlaying ? "Resume Playing" : "Play S2, E1")
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .buttonStyle(TVButtonStyle())
                .focused($viewFocused)
                .onAppear {
                    // Only request focus if not part of another button
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        viewFocused = true
                    }
                }
                .padding(.vertical, 10)
            }
            
            // Description
            Text("Narrated by Simon Smith, this documentary showcases nature's heroes from different places of Earth. Spotlighting amazing creatures and...")
                .foregroundColor(.white)
                .font(.system(size: 18))
                .lineLimit(3)
            
            HStack {
                Text("more")
                    .foregroundColor(.blue)
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                Spacer()
            }
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 40)
        }
        .buttonStyle(PlainButtonStyle()) // Use plain style for the entire view button
        .focused($viewFocused) // Bind to focus state
        .onAppear {
            // Request focus on the view when it appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                viewFocused = true
            }
            
            // Preload the video player in the background
            if !preloadedPlayer {
                DispatchQueue.global(qos: .userInitiated).async {
                    // Use the safer prepare method instead of directly accessing
                    _ = VideoPlayerView.preloadedPlayer
                    VideoPlayerView.preparePlayer()
                    preloadedPlayer = true
                }
            }
        }
        
        // Use fullScreenCover instead of sheet for full screen presentation
        .fullScreenCover(isPresented: $showVideoPlayer) {
            VideoPlayerView()
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity) // Add a smoother transition
        }
        
        .overlay(
            LinearGradient(
                gradient: Gradient(colors: [.black, .black.opacity(0.8), .black.opacity(0.4), .clear]),
                startPoint: .bottom,
                endPoint: .center
            )
        )
    }
}

struct TVButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .brightness(configuration.isPressed ? 0.2 : 0)
            .shadow(color: configuration.isPressed ? Color.white.opacity(0.6) : Color.clear, radius: 5)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct DocumentaryDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            DocumentaryDetailsView()
        }
        .preferredColorScheme(.dark)
    }
}
