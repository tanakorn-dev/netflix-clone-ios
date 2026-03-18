import SwiftUI

struct DownloadsView: View {
    // Mock: start with no downloads, can add via button
    @State private var downloads: [Movie] = []

    var body: some View {
        VStack(spacing: 0) {
            navBar
            if downloads.isEmpty {
                emptyState
            } else {
                downloadsList
            }
        }
        .netflixScreen()
    }

    // MARK: Nav bar
    private var navBar: some View {
        HStack {
            Text("Downloads")
                .netflixText(.detailTitle)
            Spacer()
            Button {} label: {
                Image(systemName: "arrow.down.circle")
                    .foregroundColor(NetflixTheme.Colors.textPrimary)
                    .font(.system(size: 22))
            }
        }
        .padding(.horizontal, NetflixTheme.Spacing.md)
        .padding(.vertical, NetflixTheme.Spacing.md)
    }

    // MARK: Empty state
    private var emptyState: some View {
        VStack(spacing: NetflixTheme.Spacing.lg) {
            Spacer()
            ZStack {
                Circle()
                    .stroke(NetflixTheme.Colors.separator, lineWidth: 2)
                    .frame(width: 100, height: 100)
                Image(systemName: "arrow.down.circle")
                    .font(.system(size: 44))
                    .foregroundColor(NetflixTheme.Colors.textPrimary)
            }
            VStack(spacing: NetflixTheme.Spacing.sm) {
                Text("Downloads are here")
                    .netflixText(.detailTitle)
                Text("All your downloaded shows and movies will appear here.")
                    .netflixText(.body)
                    .foregroundColor(NetflixTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, NetflixTheme.Spacing.xxl)
            }
            NetflixButton(title: "Find Something to Download", style: .primary) {
                // Demo: add a mock download
                if let movie = MockData.movies.randomElement() {
                    withAnimation { downloads.append(movie) }
                }
            }
            .padding(.top, NetflixTheme.Spacing.sm)
            Spacer()
        }
    }

    // MARK: Downloads list
    private var downloadsList: some View {
        List {
            ForEach(downloads) { movie in
                HStack(spacing: NetflixTheme.Spacing.md) {
                    PosterImage(url: movie.thumbnailURL, width: 80, height: 56)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(movie.title).netflixText(.cardTitle)
                        Text(movie.duration).netflixText(.caption)
                    }
                    Spacer()
                    Image(systemName: "ellipsis")
                        .foregroundColor(NetflixTheme.Colors.textSecondary)
                }
                .listRowBackground(NetflixTheme.Colors.background)
            }
            .onDelete { downloads.remove(atOffsets: $0) }
        }
        .listStyle(.plain)
    }
}

#Preview { DownloadsView() }
