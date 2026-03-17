import SwiftUI

struct SearchView: View {
    @State private var query = ""

    var body: some View {
        ZStack {
            NetflixTheme.Colors.background.ignoresSafeArea()
            VStack {
                Text("Search")
                    .font(NetflixTheme.Typography.detailTitle)
                    .foregroundColor(NetflixTheme.Colors.textPrimary)
                Text("TODO: Phase 3")
                    .foregroundColor(NetflixTheme.Colors.textSecondary)
            }
        }
    }
}

struct DownloadsView: View {
    var body: some View {
        ZStack {
            NetflixTheme.Colors.background.ignoresSafeArea()
            VStack(spacing: NetflixTheme.Spacing.md) {
                Text("Downloads")
                    .font(NetflixTheme.Typography.detailTitle)
                    .foregroundColor(NetflixTheme.Colors.textPrimary)
                Text("TODO: Phase 3")
                    .foregroundColor(NetflixTheme.Colors.textSecondary)
            }
        }
    }
}

struct MovieDetailView: View {
    let movie: Movie

    var body: some View {
        ZStack {
            NetflixTheme.Colors.background.ignoresSafeArea()
            VStack {
                Text(movie.title)
                    .font(NetflixTheme.Typography.detailTitle)
                    .foregroundColor(NetflixTheme.Colors.textPrimary)
                Text("TODO: Phase 3")
                    .foregroundColor(NetflixTheme.Colors.textSecondary)
            }
        }
    }
}

struct VideoPlayerView: View {
    let movie: Movie

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("Playing: \(movie.title)")
                    .foregroundColor(.white)
                Text("TODO: Phase 3 — AVPlayer integration")
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview { SearchView() }
#Preview { DownloadsView() }
#Preview { MovieDetailView(movie: MockData.heroMovie) }
#Preview { VideoPlayerView(movie: MockData.heroMovie) }
