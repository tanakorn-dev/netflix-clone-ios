# netflix-clone-ios

A pixel-perfect Netflix iOS clone built with SwiftUI.

## Tech Stack
- SwiftUI (iOS 17+)
- Swift 5.9
- Xcode 15+

## Project Structure

```
NetflixClone/
├── Core/               # Theme, extensions, modifiers
│   ├── Theme.swift     # All design tokens (colors, spacing, fonts)
│   └── Extensions/
├── Features/           # One folder per screen
│   ├── Auth/           # Splash, SignIn
│   ├── Home/           # Home feed, TabView
│   ├── Search/
│   ├── Detail/         # Movie detail page
│   ├── Downloads/
│   ├── Profile/        # Profile picker
│   └── Player/         # Video player
├── Components/         # Reusable UI components
│   ├── Cards/          # MovieCard
│   ├── Buttons/        # NetflixButton
│   ├── Navigation/     # TopNavBar, TabBar
│   ├── HeroBanner/
│   └── ContentRow/
├── Models/             # Data models + MockData
└── Resources/          # Assets, fonts
```

## Build Phases

| Phase | Status | Description |
|-------|--------|-------------|
| 1 — Analysis & setup | ✅ Done | Project structure, models, design tokens |
| 2 — Design system | 🔄 Next | ViewModifiers, component previews |
| 3 — Components | ⏳ Pending | Cards, rows, hero banner, buttons |
| 4 — Screen assembly | ⏳ Pending | Full screens + navigation |

## Getting Started

```bash
git clone https://github.com/YOUR_USERNAME/netflix-clone-ios.git
cd netflix-clone-ios
open NetflixClone.xcodeproj
```

Select any simulator (iPhone 15 recommended) and press `Cmd+R` to run.

## Design Tokens

All design values live in `Core/Theme.swift`:

```swift
NetflixTheme.Colors.netflixRed     // #E50914
NetflixTheme.Colors.background     // #141414
NetflixTheme.Spacing.cardWidth     // 104pt
NetflixTheme.Typography.rowHeader  // 16pt medium
```
