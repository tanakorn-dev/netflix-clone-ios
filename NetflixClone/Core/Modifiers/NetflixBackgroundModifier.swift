import SwiftUI

// MARK: - Screen Background Modifier
// Usage: VStack { ... }.netflixScreen()

struct NetflixScreenModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            NetflixTheme.Colors.background
                .ignoresSafeArea()
            content
        }
    }
}

// MARK: - Gradient Overlay (used on Hero banner bottom fade)
struct NetflixGradientOverlayModifier: ViewModifier {
    var direction: Edge = .bottom

    func body(content: Content) -> some View {
        content.overlay(
            LinearGradient(
                colors: [.clear, NetflixTheme.Colors.background],
                startPoint: startPoint,
                endPoint: endPoint
            )
        )
    }

    private var startPoint: UnitPoint {
        switch direction {
        case .bottom: return .top
        case .top:    return .bottom
        case .leading: return .trailing
        case .trailing: return .leading
        }
    }
    private var endPoint: UnitPoint {
        switch direction {
        case .bottom: return .bottom
        case .top:    return .top
        case .leading: return .leading
        case .trailing: return .trailing
        }
    }
}

// MARK: - Shimmer loading effect
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        .clear,
                        NetflixTheme.Colors.textSecondary.opacity(0.15),
                        .clear
                    ],
                    startPoint: .init(x: phase - 0.3, y: 0),
                    endPoint:   .init(x: phase + 0.3, y: 0)
                )
            )
            .onAppear {
                withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                    phase = 1.3
                }
            }
    }
}

extension View {
    func netflixScreen() -> some View {
        modifier(NetflixScreenModifier())
    }

    func netflixGradientOverlay(direction: Edge = .bottom) -> some View {
        modifier(NetflixGradientOverlayModifier(direction: direction))
    }

    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}
