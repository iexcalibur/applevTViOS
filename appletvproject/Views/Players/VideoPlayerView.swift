import SwiftUI
import AVKit

struct VideoPlayerView: View {
    // Create a static preloaded player instance that can be shared - make it public
    public static let preloadedPlayer: AVPlayer = {
        // Use a publicly available sample video as fallback
        let sampleURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        let player = AVPlayer(url: sampleURL)
        // Don't attempt preroll here - we'll handle readiness in a better way
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    // Add a status observer to know when the player is ready
    public static func preparePlayer() {
        // Prepare the player by loading its asset
        if let currentItem = preloadedPlayer.currentItem {
            // Start loading metadata and prepare for playback
            currentItem.asset.loadValuesAsynchronously(forKeys: ["playable"]) {
                // Only preroll once the asset is playable
                var error: NSError? = nil
                let status = currentItem.asset.statusOfValue(forKey: "playable", error: &error)
                if status == .loaded {
                    DispatchQueue.main.async {
                        preloadedPlayer.preroll(atRate: 1.0) { _ in }
                    }
                }
            }
        }
    }
    
    // Use a reference to the shared player
    let player: AVPlayer
    
    // Add dismiss action for close button
    @Environment(\.dismiss) private var dismiss
    
    // State variables for UI controls
    @State private var showControls = true
    @State private var isPlaying = true
    @State private var currentTime: Double = 0
    @State private var duration: Double = 1.0
    @State private var volume: Float = 1.0
    @State private var isMuted: Bool = false
    @State private var showVolumeControls = false
    @State private var showInfoPanel = true
    @State private var selectedContent: String = "Info"
    
    // Add state variable for YouTube-style info mode
    @State private var infoModeActive = false
    
    // Reference to PiP controller
    @State private var pipController: AVPictureInPictureController?
    
    // Add player layer for PiP
    @State private var playerLayer: AVPlayerLayer?
    
    // Add a flag to prevent multiple close button taps
    @State private var isDismissing = false
    
    // Mock data for video information
    let videoTitle = "Amazing Earth"
    let videoSubtitle = "A New Pattern"
    let videoDescription = "A short animated film about a giant rabbit dealing with three bullying rodents."
    let videoEpisodeInfo = "Short Film • 10 minutes"
    
    // Add the EnvironmentObject to VideoPlayerView
    @EnvironmentObject private var playbackStateManager: PlaybackStateManager
    
    // Initialize with a default video URL
    init(resumeFrom: Double? = nil) {
        // Use the preloaded player
        self.player = VideoPlayerView.preloadedPlayer
        
        // If resumeFrom time is provided, seek to that position
        if let resumeFrom = resumeFrom {
            let targetTime = CMTime(seconds: resumeFrom, preferredTimescale: 1000)
            _currentTime = State(initialValue: resumeFrom)
            player.seek(to: targetTime)
        }
    }
    
    var body: some View {
        ZStack {
            // Immediately show the video player to avoid delay
            VideoPlayer(player: player)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    Color.black.opacity(0.01)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showControls.toggle()
                                // Hide volume controls when tapping the screen
                                if showVolumeControls {
                                    showVolumeControls = false
                                }
                            }
                        }
                )
                // Use background to get UIView representable for PiP
                .background(
                    PipLayerRepresentable(player: player, playerLayer: $playerLayer)
                        .frame(width: 0, height: 0)
                )
            
            if infoModeActive {
                // Use the YouTube-style layout component
                YouTubeStyleLayout(
                    player: player,
                    videoTitle: videoTitle,
                    videoDescription: videoDescription,
                    showControls: $showControls,
                    isPlaying: $isPlaying,
                    currentTime: $currentTime,
                    duration: $duration,
                    showInfoPanel: $showInfoPanel,
                    selectedContent: $selectedContent,
                    infoModeActive: $infoModeActive
                )
            } else if showControls {
                // Full screen controls overlay
                FullScreenControlsView(
                    player: player,
                    videoTitle: videoTitle,
                    videoSubtitle: videoSubtitle,
                    isPlaying: $isPlaying,
                    currentTime: $currentTime,
                    duration: $duration,
                    showInfoPanel: $showInfoPanel,
                    infoModeActive: $infoModeActive,
                    selectedContent: $selectedContent,
                    volume: $volume,
                    isMuted: $isMuted,
                    showVolumeControls: $showVolumeControls,
                    dismiss: dismissPlayer 
                )
                .transition(.opacity)
            }
        }
        .onAppear {
            // Reset dismissing state when view appears
            isDismissing = false
            
            // Play immediately to avoid delay
            player.play()
            
            // Setup other aspects of the player in the background
            DispatchQueue.main.async {
                setupVideoPlayer()
                setupPictureInPicture() // Set up PiP
            }
            
            // Auto-hide controls after 5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                withAnimation {
                    showControls = false
                }
            }
            
            // Listen for PiP toggle notification
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("TogglePictureInPicture"),
                object: nil,
                queue: .main
            ) { _ in
                togglePictureInPicture()
            }
        }
        .onDisappear {
            // Save the current playback state when leaving
            playbackStateManager.updatePlaybackState(
                title: videoTitle,
                currentTime: currentTime,
                duration: duration
            )
            
            player.pause()
            // Remove time observer when view disappears
            if let timeObserverToken = timeObserverToken {
                player.removeTimeObserver(timeObserverToken)
                self.timeObserverToken = nil
            }
            
            // Remove notification observer
            NotificationCenter.default.removeObserver(
                self, 
                name: NSNotification.Name("TogglePictureInPicture"),
                object: nil
            )
        }
    }
    
    // Improved dismiss function to prevent multiple taps
    private func dismissPlayer() {
        // Prevent multiple taps from causing issues
        guard !isDismissing else { return }
        
        // Set dismissing flag to true
        isDismissing = true
        
        // Pause player
        player.pause()
        
        // Perform dismissal with slight delay to ensure animations complete properly
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            dismiss()
        }
    }
    
    // Set up Picture-in-Picture controller
    private func setupPictureInPicture() {
        #if os(tvOS)
        // PiP not available on tvOS
        #else
        if AVPictureInPictureController.isPictureInPictureSupported() {
            // Wait for playerLayer to be available
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                guard let playerLayer = playerLayer, pipController == nil else { return }
                // Create PiP controller with the created layer
                pipController = AVPictureInPictureController(playerLayer: playerLayer)
            }
        }
        #endif
    }
    
    // Function to toggle Picture-in-Picture
    private func togglePictureInPicture() {
        #if !os(tvOS) // Not available on tvOS
        guard let pipController = pipController else {
            // If PiP controller not ready yet, try setup again
            setupPictureInPicture()
            return
        }
        
        if pipController.isPictureInPictureActive {
            pipController.stopPictureInPicture()
        } else {
            pipController.startPictureInPicture()
        }
        #endif
    }
    
    // Time observer token for tracking playback
    @State private var timeObserverToken: Any? = nil
    
    // Set up the video player with time observation
    private func setupVideoPlayer() {
        player.isMuted = false
        isMuted = player.isMuted
        volume = player.volume
        isPlaying = true
        
        // Get the duration of the video
        if let currentItem = player.currentItem {
            let seconds = currentItem.asset.duration.seconds
            duration = seconds.isNaN ? 0 : seconds
        }
        
        // Add a periodic time observer to update the current time
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 1000), queue: .main) { [self] time in
            currentTime = time.seconds
            
            // Update the duration if it wasn't available initially
            if let currentItem = player.currentItem, duration <= 1.0 || duration.isNaN {
                let seconds = currentItem.asset.duration.seconds
                if !seconds.isNaN {
                    duration = seconds
                }
            }
        }
    }
    
    // Format time in MM:SS
    private func formatTime(_ timeInSeconds: Double) -> String {
        let minutes = Int(timeInSeconds) / 60
        let seconds = Int(timeInSeconds) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// UIViewRepresentable to get AVPlayerLayer for PiP
#if !os(tvOS)
struct PipLayerRepresentable: UIViewRepresentable {
    let player: AVPlayer
    @Binding var playerLayer: AVPlayerLayer?
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let layer = AVPlayerLayer(player: player)
        view.layer.addSublayer(layer)
        playerLayer = layer // Store reference to player layer
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let layer = uiView.layer.sublayers?.first as? AVPlayerLayer {
            layer.frame = uiView.bounds
        }
    }
}
#endif

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView()
            .preferredColorScheme(.dark)
    }
}
