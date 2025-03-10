//
//  appletvprojectApp.swift
//  appletvproject
//
//  Created by Shubham on 10/03/25.
//

import SwiftUI
import SwiftData
import AVKit

@main
struct appletvprojectApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @StateObject private var playbackStateManager = PlaybackStateManager()
    
    init() {
        // Preload the video player at app startup, but properly
        DispatchQueue.global(qos: .userInitiated).async {
            print("Preloading video player")
            // Instead of just accessing the player, use the prepare method
            // This will make sure we don't attempt preroll until ready
            _ = VideoPlayerView.preloadedPlayer  // Initialize the player first
            VideoPlayerView.preparePlayer()       // Then prepare it safely
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(playbackStateManager)
        }
        .modelContainer(sharedModelContainer)
    }
}
