import SwiftUI

// MARK: - Movie Card
// Standard card used in all horizontal scroll rows.
// Usage:
//   MovieCard(movie: movie)
//   MovieCard(movie: movie, size: .large)

struct MovieCard: View {
    enum Size {
        case small   // 80×120  — search results
        case medium  // 104×156 — default row card
        case large   // 130×195 — top-10 row
        case wide    // 240×135 — continue watching

        var width: CGFloat {
            switch self { case .small: 80; case .medium: 104; case .large: 130; case .wide: 240 }
        }
        var height: CGFloat {
            switch self { case .small: 120; case .medium: 156; case .large: 195; case .wide: 135 }
        }
    }

    let movie: Movie
    var size: Size = .medium
    var onTap: (() -> Void)? = nil

    @State private var isPressed = false

    var body: some View {
        Button {
            onTap?()
        } label: {
            ZStack(alignment: .bottomLeading) {
                PosterImage(
                    url: movie.thumbnailURL,
                    width: size.width,
                    height: size.height
                )

                // Top-10 rank number overlay (large size only)
                if size == .large {
                    rankOverlay
                }

                // Bottom gradient + match badge
                if size != .small {
                    bottomOverlay
                }
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded   { _ in isPressed = false }
        )
    }

    private var rankOverlay: some View {
        Text(movie.title.prefix(1))   // placeholder — replace with rank number from row index
            .font(.system(size: 56, weight: .black))
            .foregroundStyle(
                LinearGradient(
                    colors: [NetflixTheme.Colors.textPrimary, NetflixTheme.Colors.textTertiary],
                    startPoint: .top, endPoint: .bottom
                )
            )
            .offset(x: -8, y: 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    }

    private var bottomOverlay: some View {
        VStack(alignment: .leading, spacing: 2) {
            Spacer()
            LinearGradient(
                colors: [.clear, NetflixTheme.Colors.background.opacity(0.8)],
                startPoint: .top, endPoint: .bottom
            )
            .frame(height: 40)
        }
    }
}

// MARK: - Preview
#Preview {
    ScrollView(.horizontal) {
        HStack(spacing: 8) {
            MovieCard(movie: MockData.heroMovie, size: .small)
            MovieCard(movie: MockData.heroMovie, size: .medium)
            MovieCard(movie: MockData.heroMovie, size: .large)
            MovieCard(movie: MockData.heroMovie, size: .wide)
        }
        .padding()
    }
    .netflixScreen()
}
