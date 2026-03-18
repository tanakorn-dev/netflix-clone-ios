# Netflix Clone iOS

A pixel-perfect Netflix iOS clone built with SwiftUI.

## Tech Stack

- SwiftUI (iOS 17+)
- Swift 5.9
- Xcode 15+
- AVFoundation (video player scaffold)

## Project Structure

```
NetflixClone/
├── Core/
│   ├── Theme.swift                    # Design tokens: colors, spacing, typography
│   ├── AppRouter.swift                # Navigation state (EnvironmentObject)
│   ├── AnimationConstants.swift       # Shared animation presets
│   ├── NetflixCloneApp.swift          # App entry + font registration
│   ├── Extensions/
│   │   ├── CachedAsyncImage.swift     # 2-level image cache (NSCache + disk)
│   │   ├── FloatingLabelTextField.swift # Animated floating placeholder field
│   │   ├── Color+Extensions.swift
│   │   ├── View+Extensions.swift
│   │   └── String+Extensions.swift
│   └── Modifiers/
│       ├── NetflixTextModifier.swift
│       ├── NetflixCardModifier.swift
│       └── NetflixBackgroundModifier.swift
├── Features/
│   ├── Auth/
│   │   ├── SplashView.swift           # Logo animation → AuthView
│   │   └── SignInView.swift           # Email sign-in, Get help accordion
│   ├── Profile/
│   │   └── ProfilePickerView.swift    # Crossfade backdrop, profile grid
│   ├── Home/
│   │   ├── HomeView.swift             # Hero banner + content rows
│   │   └── MainTabView.swift          # Bottom tab navigation
│   ├── Search/
│   ├── Detail/                        # Movie detail sheet
│   ├── Downloads/
│   └── Player/                        # AVPlayer scaffold
├── Components/
│   ├── Cards/                         # MovieCard, ProfileAvatar, PosterImage
│   ├── Buttons/                       # NetflixButton, BadgeLabel
│   ├── Navigation/                    # TopNavBar
│   ├── HeroBanner/
│   └── ContentRow/
├── Models/
│   ├── Movie.swift
│   ├── Profile.swift
│   └── MockData.swift                 # 12 movies, 4 TMDB backdrop URLs
└── Resources/
    ├── Assets.xcassets/
    │   └── Netflix_Logo.imageset/     # SVG vector logo
    ├── BebasNeue.otf                  # Logo font (Splash + SignIn)
    └── NetflixSans-*.ttf              # 12 weights — all UI text
```

## Screens

| Screen | Status | Notes |
|--------|--------|-------|
| Splash | ✅ | Logo spring animation |
| Sign In | ✅ | Floating label field, Get help accordion, gradient bg |
| Profile Picker | ✅ | TMDB crossfade backdrop, 2-level image cache |
| Home | 🔄 | Hero banner, content rows |
| Search | 🔄 | — |
| Detail | 🔄 | Movie detail sheet |
| Downloads | 🔄 | — |
| Player | 🔄 | AVPlayer scaffold |

## Typography

Netflix Sans is registered at runtime via `CTFontManagerRegisterFontsForURL` — no `Info.plist` entry needed.

```swift
// Semantic tokens
NetflixTheme.Typography.heroTitle      // NetflixSans-Bold 30pt
NetflixTheme.Typography.body           // NetflixSans-Regular 14pt

// Helper functions
NetflixTheme.Typography.bold(18)       // NetflixSans-Bold 18pt
NetflixTheme.Typography.medium(15)     // NetflixSans-Medium 15pt
NetflixTheme.Typography.regular(13)    // NetflixSans-Regular 13pt

// Logo only
NetflixTheme.Typography.netflixLogoSize(36)  // BebasNeue 36pt
```

## Image Cache

`CachedAsyncImage` provides 2-level caching:

- **Level 1 — Memory** (NSCache): instant, 100 images / 150 MB, cleared on kill
- **Level 2 — Disk** (FileManager): survives app restarts, 7-day expiry, 200 MB limit

```swift
CachedAsyncImage(url: movie.backdropURL, contentMode: .fill)
CachedAsyncImage(url: movie.thumbnailURL, width: 104, height: 156, cornerRadius: 4)
```

## Design Tokens

```swift
NetflixTheme.Colors.netflixRed     // #E50914
NetflixTheme.Colors.background     // #141414
NetflixTheme.Spacing.md            // 16pt
NetflixTheme.Spacing.lg            // 24pt
```

## Getting Started

```bash
git clone https://github.com/YOUR_USERNAME/netflix-clone-ios.git
cd netflix-clone-ios
open NetflixClone.xcodeproj
```

Select any iPhone simulator (iPhone 16 Pro recommended) and press `Cmd+R`.
