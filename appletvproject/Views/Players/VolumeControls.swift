import SwiftUI
import AVKit

// Volume controls dropdown view
public struct VolumeControlsView: View {
    let player: AVPlayer
    @Binding var volume: Float
    @Binding var isMuted: Bool
    
    public var body: some View {
        VStack(spacing: 10) {
            // Removed separate mute button
            
            // Volume slider
            VStack(alignment: .leading, spacing: 5) {
                Text("Volume")
                    .font(.caption)
                    .foregroundColor(.white)
                
                // Volume slider
                Slider(value: $volume, in: 0...1) { editing in
                    if !editing {
                        // Apply volume change to the player
                        player.volume = volume
                        
                        // Update muted state based on volume
                        if volume > 0 && isMuted {
                            isMuted = false
                            player.isMuted = false
                        } else if volume == 0 && !isMuted {
                            isMuted = true
                            player.isMuted = true
                        }
                    }
                }
                .accentColor(.white)
                .frame(width: 150) // Set a fixed width for the slider
            }
            .padding(10)
            .background(Color.black.opacity(0.6))
            .cornerRadius(8)
        }
        .padding(10)
        .background(Color.black.opacity(0.5))
        .cornerRadius(10)
    }
}

// Helper function to determine volume icon
public func volumeIconName(volume: Float, isMuted: Bool) -> String {
    if isMuted || volume == 0 {
        return "speaker.slash"
    } else if volume < 0.25 {
        return "speaker"
    } else if volume < 0.5 {
        return "speaker.wave.1"
    } else if volume < 0.75 {
        return "speaker.wave.2"
    } else {
        return "speaker.wave.3"
    }
}
