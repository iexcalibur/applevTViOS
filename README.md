# Apple TV Project

## Overview
This is a ioS application designed to provide a streaming media experience similar to Apple TV. The app features a tabbed interface with content browsing, video playback, and an interactive user experience optimized for the Apple TV platform.

## Features
- **Home Screen**: Displays featured content, seasons, bonus content, and cast & crew information
- **Video Player**: Full-featured video player with playback controls, volume adjustment, and Picture-in-Picture support
- **Tabbed Navigation**: iOS-style tab navigation for different sections of the application
- **Resume Playback**: Ability to resume video from where the user left off
- **YouTube-style Info Panels**: Information panels that can be displayed during video playback

## Project Architecture
This project follows the Model-View-ViewModel (MVVM) architecture pattern for better separation of concerns and maintainability.

```
appletvproject/
├── App/
│   └── appletvprojectApp.swift
├── Models/
│   └── Item.swift
├── ViewModels/
│   └── PlaybackStateManager.swift
├── Views/
│   ├── Main/
│   │   ├── ContentView.swift
│   │   ├── HomeView.swift
│   │   └── TabView.swift
│   ├── Components/
│   │   ├── CardComponents.swift
│   │   ├── HeaderView.swift
│   │   └── PreferenceKeys.swift
│   ├── Content/
│   │   ├── BonusContentSection.swift
│   │   ├── CastCrewSection.swift
│   │   ├── ContentPanels.swift
│   │   ├── DocumentaryDetailsView.swift
│   │   └── SeasonSection.swift
│   └── Player/
│       ├── FullScreenControls.swift
│       ├── PlayerControlsView.swift
│       ├── VideoPlayerView.swift
│       ├── VolumeControls.swift
│       └── YouTubeStyleLayout.swift
└── Utilities/
```

## Architecture Components

### Models
Contains the data models used throughout the application.
- **Item**: SwiftData model for content items

### ViewModels
Responsible for preparing and managing data for the views.
- **PlaybackStateManager**: Manages video playback state, including tracking played content, progress, and duration

### Views
Organized into several subdirectories:

#### Main Views
- **ContentView**: The main container view that handles tab switching
- **HomeView**: The primary content view showing various content sections
- **TabView**: Custom tab navigation similar to Apple TV interface

#### Component Views
- **CardComponents**: Reusable UI components for content cards
- **HeaderView**: Header component for the main screen
- **PreferenceKeys**: SwiftUI preference keys for handling scroll view positioning

#### Content Views
- **BonusContentSection**: Shows bonus video content
- **CastCrewSection**: Displays cast and crew information
- **ContentPanels**: Informational panels used throughout the app
- **DocumentaryDetailsView**: Detail view for documentary content
- **SeasonSection**: View for showing season-based content

#### Player Views
- **VideoPlayerView**: Main video player view with AVKit integration
- **FullScreenControls**: Overlay controls for the video player
- **PlayerControlsView**: Playback controls for the video player
- **VolumeControls**: Volume adjustment controls
- **YouTubeStyleLayout**: Information panel layout inspired by YouTube

## Key Features Implementation

### Video Playback
The app uses AVKit for video playback with a preloaded player for better performance. Picture-in-Picture is supported on compatible platforms.

### Resume Playback
The PlaybackStateManager tracks playback progress, allowing users to resume videos where they left off.

### Tab Navigation
Custom tab navigation mimics the Apple TV interface with focused states and smooth transitions.

# Project Restructuring Guide

This document provides instructions for reorganizing the current flat project structure into an MVVM architecture.

## Recommended Folder Structure

```
appletvproject/
├── App/
│   └── appletvprojectApp.swift
├── Models/
│   └── Item.swift
├── ViewModels/
│   └── PlaybackStateManager.swift
├── Views/
│   ├── Main/
│   │   ├── ContentView.swift
│   │   ├── HomeView.swift
│   │   └── TabView.swift
│   ├── Components/
│   │   ├── CardComponents.swift
│   │   ├── HeaderView.swift
│   │   └── PreferenceKeys.swift
│   ├── Content/
│   │   ├── BonusContentSection.swift
│   │   ├── CastCrewSection.swift
│   │   ├── ContentPanels.swift
│   │   ├── DocumentaryDetailsView.swift
│   │   └── SeasonSection.swift
│   └── Player/
│       ├── FullScreenControls.swift
│       ├── PlayerControlsView.swift
│       ├── VideoPlayerView.swift
│       ├── VolumeControls.swift
│       └── YouTubeStyleLayout.swift
└── Utilities/
```

## Restructuring Steps

1. In Xcode, create the following folder groups:
   - App
   - Models
   - ViewModels
   - Views
     - Main
     - Components
     - Content
     - Player
   - Utilities

2. Move files to their respective folders:

   **App**:
   - appletvprojectApp.swift (Extract PlaybackStateManager to its own file)

   **Models**:
   - Item.swift

   **ViewModels**:
   - Create PlaybackStateManager.swift (extracted from appletvprojectApp.swift)

   **Views/Main**:
   - ContentView.swift
   - HomeView.swift
   - TabView.swift

   **Views/Components**:
   - CardComponents.swift
   - HeaderView.swift
   - PreferenceKeys.swift

   **Views/Content**:
   - BonusContentSection.swift
   - CastCrewSection.swift
   - ContentPanels.swift
   - DocumentaryDetailsView.swift
   - SeasonSection.swift

   **Views/Player**:
   - FullScreenControls.swift
   - PlayerControlsView.swift
   - VideoPlayerView.swift
   - VolumeControls.swift
   - YouTubeStyleLayout.swift

3. Update imports if necessary after moving files

## File Modifications

### Create PlaybackStateManager.swift
Extract the PlaybackStateManager class from appletvprojectApp.swift into its own file in the ViewModels folder.

### Update appletvprojectApp.swift
Remove the PlaybackStateManager class and add an import for the new file.

## Benefits of this Structure

- **Separation of Concerns**: Clear distinction between different parts of the application
- **Improved Maintainability**: Easier to find and update specific components
- **Better Testability**: Easier to write unit tests for individual components
- **Scalability**: Structure supports growth as new features are added
- **Code Reusability**: Components are modular and can be reused across the app
