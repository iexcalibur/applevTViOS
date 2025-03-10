import SwiftUI
import AVKit

// YouTube-style layout view
struct YouTubeStyleLayout: View {
    let player: AVPlayer
    let videoTitle: String
    let videoDescription: String
    @Binding var showControls: Bool
    @Binding var isPlaying: Bool
    @Binding var currentTime: Double
    @Binding var duration: Double
    @Binding var showInfoPanel: Bool
    @Binding var selectedContent: String
    @Binding var infoModeActive: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Video player at top with fixed height
            ZStack {
                VideoPlayer(player: player)
                    .frame(height: 400)
                    .overlay(
                        Color.black.opacity(0.01)
                            .onTapGesture {
                                withAnimation {
                                    showControls.toggle()
                                }
                            }
                    )
                    
                // Custom Controls Overlay in mini player mode
                if showControls {
                    YouTubePlayerControls(
                        player: player,
                        isPlaying: $isPlaying,
                        currentTime: $currentTime,
                        duration: duration,
                        infoModeActive: $infoModeActive
                    )
                    .background(Color.black.opacity(0.5))
                    .frame(height: 400)
                    .transition(.opacity)
                }
            }
            .frame(height: 400)
            
            // Content below video
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Content selection buttons
                    ContentSelectionButtons(
                        selectedContent: $selectedContent,
                        showInfoPanel: $showInfoPanel,
                        infoModeActive: $infoModeActive
                    )
                    
                    // Show selected content panel
                    if showInfoPanel {
                        contentPanel
                            .padding(.top, 10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
            .background(Color.black)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 20)
            }
        }
    }
    
    // Select the appropriate content panel based on selection
    @ViewBuilder
    private var contentPanel: some View {
        if selectedContent == "Info" {
            InfoContentPanel(
                player: player,
                videoTitle: videoTitle,
                videoDescription: videoDescription,
                isPlaying: $isPlaying
            )
        } else if selectedContent == "Insight" {
            InsightContentPanel()
        } else {
            ContinueContentPanel()
        }
    }
}

// YouTube-style player controls
struct YouTubePlayerControls: View {
    let player: AVPlayer
    @Binding var isPlaying: Bool
    @Binding var currentTime: Double
    let duration: Double
    @Binding var infoModeActive: Bool
    
    // Format time in MM:SS
    private func formatTime(_ timeInSeconds: Double) -> String {
        let minutes = Int(timeInSeconds) / 60
        let seconds = Int(timeInSeconds) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var body: some View {
        VStack {
            // Top control bar with close, PiP, AirPlay and volume buttons
            HStack(spacing: 25) {
                // Close button
                Button(action: {
                    withAnimation {
                        infoModeActive = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                // PiP button
                Button(action: {}) {
                    Image(systemName: "rectangle.on.rectangle")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                
                // AirPlay button
                Button(action: {}) {
                    Image(systemName: "airplayvideo")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                // Volume button
                Button(action: {}) {
                    Image(systemName: "speaker.wave.3")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 20)
            .padding(.top, 60)
            
            Spacer()
            
            // Center playback controls
            HStack(spacing: 40) {
                // Rewind 10 seconds
                Button(action: {
                    player.seek(to: CMTime(seconds: max(0, currentTime - 10), preferredTimescale: 1000))
                }) {
                    ZStack {
                        VStack {
                            Image(systemName: "gobackward")
                                .font(.system(size: 16))
                            Text("10")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .foregroundColor(.white)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // Play/Pause
                Button(action: {
                    isPlaying.toggle()
                    if isPlaying {
                        player.play()
                    } else {
                        player.pause()
                    }
                }) {
                    Image(systemName: isPlaying ? "pause" : "play.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                .focusable(true)
                
                // Forward 10 seconds
                Button(action: {
                    player.seek(to: CMTime(seconds: min(duration, currentTime + 10), preferredTimescale: 1000))
                }) {
                    ZStack {
                        VStack {
                            Image(systemName: "goforward")
                                .font(.system(size: 16))
                            Text("10")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .foregroundColor(.white)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Spacer()
            
            // Progress bar
            VStack(spacing: 4) {
                Slider(value: $currentTime, in: 0...duration) { editing in
                    if !editing {
                        player.seek(to: CMTime(seconds: currentTime, preferredTimescale: 1000))
                    }
                }
                .accentColor(.white)
                
                // Time indicators
                HStack {
                    Text(formatTime(currentTime))
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                    
                    Spacer()
                    
                    Text("-" + formatTime(duration - currentTime))
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
    }
}
