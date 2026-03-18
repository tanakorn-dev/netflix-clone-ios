import SwiftUI

// MARK: - Content Row
// Full horizontal scroll row with title header.
// Usage:
//   ContentRow(row: row, onSelect: { movie in ... })
//   ContentRow(row: row, cardSize: .large)

struct ContentRowView: View {
    let row: ContentRow
    var cardSize: MovieCard.Size = .medium
    var onSelect: ((Movie) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: NetflixTheme.Spacing.sm) {
            rowHeader
            scrollingCards
        }
    }

    // MARK: Row header
    private var rowHeader: some View {
        HStack(alignment: .center) {
            Text(row.title)
                .netflixText(.rowHeader)

            Spacer()

            // "Explore All" chevron (optional)
            if row.movies.count > 5 {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(NetflixTheme.Colors.textSecondary)
            }
        }
        .padding(.horizontal, NetflixTheme.Spacing.rowPaddingH)
    }

    // MARK: Scrolling cards
    private var scrollingCards: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: NetflixTheme.Spacing.cardGap) {
                ForEach(row.movies) { movie in
                    MovieCard(movie: movie, size: cardSize) {
                        onSelect?(movie)
                    }
                }
            }
            .padding(.horizontal, NetflixTheme.Spacing.rowPaddingH)
            .padding(.vertical, 4) // room for scale animation
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 24) {
        ContentRowView(
            row: MockData.homeRows[0],
            cardSize: .medium
        )
        ContentRowView(
            row: MockData.homeRows[1],
            cardSize: .large
        )
    }
    .netflixScreen()
}
