import SwiftUI
import AVKit

// Generic control button style
struct ControlButtonView: View {
    let iconName: String
    let action: () -> Void
    let size: CGFloat
    
    init(iconName: String, size: CGFloat = 20, action: @escaping () -> Void) {
        self.iconName = iconName
        self.size = size
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.system(size: size))
                .foregroundColor(.white)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


// Central playback controls (Rewind, Play/Pause, Forward)
struct PlaybackControlsView: View {
    let player: AVPlayer
    @Binding var isPlaying: Bool
    @Binding var currentTime: Double
    let duration: Double
    
    var body: some View {
        HStack(spacing: 60) {
            // Rewind 10 seconds
            Button(action: {
                player.seek(to: CMTime(seconds: max(0, currentTime - 10), preferredTimescale: 1000))
            }) {
                VStack {
                    Image(systemName: "gobackward")
                        .font(.system(size: 20))
                    Text("10")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(.white)
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
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            .buttonStyle(PlainButtonStyle())
            .focusable(true)
            
            // Forward 10 seconds
            Button(action: {
                player.seek(to: CMTime(seconds: min(duration, currentTime + 10), preferredTimescale: 1000))
            }) {
                VStack {
                    Image(systemName: "goforward")
                        .font(.system(size: 20))
                    Text("10")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(.white)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// Progress bar with slider
struct ProgressBarView: View {
    let player: AVPlayer
    @Binding var currentTime: Double
    let duration: Double
    
    private func formatTime(_ timeInSeconds: Double) -> String {
        let minutes = Int(timeInSeconds) / 60
        let seconds = Int(timeInSeconds) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var body: some View {
        VStack(spacing: 8) {
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
                    .font(.system(size: 14))
                
                Spacer()
                
                Text("-" + formatTime(duration - currentTime))
                    .foregroundColor(.white)
                    .font(.system(size: 14))
            }
        }
    }
}
