//
//  PlaybackStateManager.swift
//  appletvproject
//
//  Created using code extracted from appletvprojectApp.swift
//

import SwiftUI

class PlaybackStateManager: ObservableObject {
    @Published var lastPlayedTitle: String = ""
    @Published var lastPlayedProgress: Double = 0
    @Published var lastPlayedDuration: Double = 0
    @Published var hasStartedPlaying: Bool = false
    
    func updatePlaybackState(title: String, currentTime: Double, duration: Double) {
        self.lastPlayedTitle = title
        self.lastPlayedProgress = currentTime
        self.lastPlayedDuration = duration
        self.hasStartedPlaying = true
    }
    
    func clearPlaybackState() {
        self.lastPlayedTitle = ""
        self.lastPlayedProgress = 0
        self.lastPlayedDuration = 0
        self.hasStartedPlaying = false
    }
}
