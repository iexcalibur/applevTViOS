import SwiftUI
import AVKit

// Controls for full screen mode
struct FullScreenControlsView: View {
    let player: AVPlayer
    let videoTitle: String
    let videoSubtitle: String
    @Binding var isPlaying: Bool
    @Binding var currentTime: Double
    @Binding var duration: Double
    @Binding var showInfoPanel: Bool
    @Binding var infoModeActive: Bool
    @Binding var selectedContent: String
    
    // Add volume control bindings
    @Binding var volume: Float
    @Binding var isMuted: Bool
    @Binding var showVolumeControls: Bool
    
    // Add caption control
    @State private var showCaptionOptions: Bool = false
    @State private var captionsEnabled: Bool = false
    
    let dismiss: () -> Void
    
    var body: some View {
        VStack {
            // Top control bar
            PlayerTopControlsView(
                onClose: dismiss,
                player: player,
                volume: $volume,
                isMuted: $isMuted,
                showVolumeControls: $showVolumeControls
            )
            .padding(.top, 60)
            
            Spacer()
            
            // Center playback controls
            PlaybackControlsView(
                player: player,
                isPlaying: $isPlaying,
                currentTime: $currentTime,
                duration: duration
            )
            
            Spacer()
            
            // Bottom info and controls
            VStack(spacing: 15) {
                // Video title and options menu
                titleAndOptionsView
                
                // Progress bar
                ProgressBarView(
                    player: player,
                    currentTime: $currentTime,
                    duration: duration
                )
                
                // Bottom buttons
                BottomButtonsView(
                    infoModeActive: $infoModeActive,
                    selectedContent: $selectedContent,
                    showInfoPanel: $showInfoPanel
                )
            }
            .padding(.horizontal, 30)
        }
        .transition(.opacity)
    }
    
    // Extracted title and caption options to simplify expressions
    private var titleAndOptionsView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(videoSubtitle)
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text(videoTitle)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Add caption button directly in the main controls for visibility
            captionButton
            
            
        }
    }
    
    // Extracted caption button for better visibility
    private var captionButton: some View {
        Button(action: {
            captionsEnabled.toggle()
            toggleCaptions()
        }) {
            Image(systemName: "captions.bubble")
                .font(.system(size: 22))
                .foregroundColor(captionsEnabled ? .yellow : .white)
                .padding(.trailing, 15)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Further extracted caption options overlay
    @ViewBuilder
    private var captionOptionsOverlay: some View {
        if showCaptionOptions {
            captionOptionsMenu
                .offset(x: -100, y: 0)
                .transition(.opacity)
        }
    }
    
    private var captionOptionsMenu: some View {
        VStack(alignment: .leading) {
            Button(action: {
                captionsEnabled.toggle()
                toggleCaptions()
                showCaptionOptions = false
            }) {
                HStack {
                    Text(captionsEnabled ? "Turn Off Captions" : "Turn On Captions")
                    Spacer()
                    if captionsEnabled {
                        Image(systemName: "checkmark")
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .foregroundColor(.white)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(10)
        .background(Color.black.opacity(0.9))
        .cornerRadius(10)
    }
    
    // Helper to toggle captions
    private func toggleCaptions() {
        guard let playerItem = player.currentItem else { return }
        guard let group = playerItem.asset.mediaSelectionGroup(forMediaCharacteristic: .legible) else { return }
        
        if captionsEnabled {
            // Find first caption option
            if let option = group.options.first {
                playerItem.select(option, in: group)
            }
        } else {
            // Disable captions
            playerItem.select(nil, in: group)
        }
    }
    
    // Compute the correct speaker icon based on volume and mute state
    private var volumeIconName: String {
        if isMuted {
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
}


// Top controls view
struct PlayerTopControlsView: View {
    let onClose: () -> Void
    let player: AVPlayer
    @Binding var volume: Float
    @Binding var isMuted: Bool
    @Binding var showVolumeControls: Bool
    
    var body: some View {
        HStack(spacing: 25) {
            // Close button
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            // PiP button - simplified implementation
            Button(action: {
                // We'll use a simple way to request PiP mode
                #if os(tvOS)
                // PiP is not available on tvOS
                #else
                if AVPictureInPictureController.isPictureInPictureSupported() {
                    NotificationCenter.default.post(
                        name: NSNotification.Name("TogglePictureInPicture"),
                        object: nil
                    )
                }
                #endif
            }) {
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
            
            // Volume button with dropdown
            VStack(alignment: .trailing) {
                // Volume button
                Button(action: {
                    withAnimation {
                        showVolumeControls.toggle()
                    }
                }) {
                    Image(systemName: volumeIconName)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
                
                // Volume controls dropdown
                if showVolumeControls {
                    VolumeControlsView(
                        player: player,
                        volume: $volume,
                        isMuted: $isMuted
                    )
                    .transition(.opacity)
                    .zIndex(1) // Ensure it's displayed above other elements
                }
            }
        }
        .padding(.horizontal, 30)
    }
    
    // Compute the correct speaker icon based on volume and mute state
    private var volumeIconName: String {
        if isMuted {
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
}

// Bottom buttons for switching to info mode
struct BottomButtonsView: View {
    @Binding var infoModeActive: Bool
    @Binding var selectedContent: String
    @Binding var showInfoPanel: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            // Info button
            ControlModeButton(
                title: "Info",
                content: "Info",
                infoModeActive: $infoModeActive,
                selectedContent: $selectedContent,
                showInfoPanel: $showInfoPanel
            )
            
            // Insight button
            ControlModeButton(
                title: "InSight",
                content: "Insight",
                infoModeActive: $infoModeActive,
                selectedContent: $selectedContent,
                showInfoPanel: $showInfoPanel
            )
            
            // Continue Watching button
            ControlModeButton(
                title: "Continue Watching",
                content: "Continue",
                infoModeActive: $infoModeActive,
                selectedContent: $selectedContent,
                showInfoPanel: $showInfoPanel
            )
        }
    }
}

// Individual control mode button
struct ControlModeButton: View {
    let title: String
    let content: String
    @Binding var infoModeActive: Bool
    @Binding var selectedContent: String
    @Binding var showInfoPanel: Bool
    
    var body: some View {
        Button(action: {
            withAnimation {
                infoModeActive = true
                selectedContent = content
                showInfoPanel = true
            }
        }) {
            Text(title)
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
