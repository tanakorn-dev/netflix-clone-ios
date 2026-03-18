import SwiftUI

// MARK: - Hero Banner
// Full-width featured movie banner at the top of the Home screen.
// Usage:
//   HeroBanner(movie: movie, onPlay: { }, onMoreInfo: { movie in })

struct HeroBanner: View {
    let movie: Movie
    var onPlay: (() -> Void)? = nil
    var onMoreInfo: ((Movie) -> Void)? = nil

    var body: some View {
        ZStack(alignment: .bottom) {
            // Backdrop image
            PosterImage(
                url: movie.backdropURL,
                contentMode: .fill,
                width: UIScreen.main.bounds.width,
                height: NetflixTheme.Spacing.heroHeight,
                cornerRadius: 0
            )

            // Bottom fade gradient
            LinearGradient(
                colors: [.clear, .clear, NetflixTheme.Colors.background],
                startPoint: .top,
                endPoint: .bottom
            )

            // Content overlay
            VStack(spacing: 0) {
                Spacer()
                movieInfo
                    .padding(.bottom, NetflixTheme.Spacing.md)
                actionButtons
                    .padding(.bottom, NetflixTheme.Spacing.lg)
            }
        }
        .frame(height: NetflixTheme.Spacing.heroHeight)
    }

    // MARK: Movie info
    private var movieInfo: some View {
        VStack(spacing: NetflixTheme.Spacing.sm) {
            // Netflix Original badge
            if movie.isNetflixOriginal {
                BadgeLabel(text: "N  S E R I E S", style: .netflixOriginal)
            }

            // Title
            Text(movie.title)
                .netflixText(.heroTitle)
                .multilineTextAlignment(.center)
                .shadow(color: .black.opacity(0.5), radius: 4)

            // Metadata row
            HStack(spacing: NetflixTheme.Spacing.sm) {
                BadgeLabel(text: "\(movie.matchPercentage)% Match", style: .match)
                Text(String(movie.year))
                    .netflixText(.caption)
                BadgeLabel(text: movie.rating, style: .rating)
                Text(movie.duration)
                    .netflixText(.caption)
            }

            // Genre tags
            Text(movie.genres.prefix(3).map(\.rawValue).joined(separator: " • "))
                .netflixText(.caption)
        }
        .fullWidth()
        .padding(.horizontal, NetflixTheme.Spacing.md)
    }

    // MARK: Action buttons
    private var actionButtons: some View {
        HStack(spacing: NetflixTheme.Spacing.md) {
            NetflixButton(title: "▶  Play", style: .primary, isFullWidth: true) {
                onPlay?()
            }
            NetflixButton(title: "ⓘ  More Info", style: .secondary, isFullWidth: true) {
                onMoreInfo?(movie)
            }
        }
        .padding(.horizontal, NetflixTheme.Spacing.md)
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        HeroBanner(movie: MockData.heroMovie)
    }
    .netflixScreen()
}
