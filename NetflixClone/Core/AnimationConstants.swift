import SwiftUI

// MARK: - Netflix Animation Curves
// Central source for all animation values.
// Usage: .animation(NetflixAnimation.spring, value: isExpanded)

enum NetflixAnimation {

    // Standard spring — card press, tab switch
    static let spring = Animation.spring(response: 0.35, dampingFraction: 0.75)

    // Snappy spring — quick interactions like badge appear
    static let snappy = Animation.spring(response: 0.25, dampingFraction: 0.8)

    // Smooth ease — scroll-driven fades, nav bar opacity
    static let smooth = Animation.easeInOut(duration: 0.25)

    // Slow fade — splash screen, full-screen transitions
    static let slowFade = Animation.easeInOut(duration: 0.5)

    // Detail sheet slide up
    static let sheetReveal = Animation.spring(response: 0.45, dampingFraction: 0.82)

    // Tab bar icon bounce
    static let tabBounce = Animation.spring(response: 0.3, dampingFraction: 0.6)

    // Hero banner auto-scroll (if cycling heroes)
    static let heroSlide = Animation.easeInOut(duration: 0.6)
}

// MARK: - Transition presets
extension AnyTransition {

    // Fade + slight scale up — detail sheet content
    static var netflixReveal: AnyTransition {
        .asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 0.96)),
            removal:   .opacity.combined(with: .scale(scale: 1.02))
        )
    }

    // Slide up from bottom — modal sheets
    static var slideUp: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal:   .move(edge: .bottom).combined(with: .opacity)
        )
    }

    // Fade only — overlays, controls
    static var netflixFade: AnyTransition {
        .opacity
    }
}
