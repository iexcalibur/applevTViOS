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
