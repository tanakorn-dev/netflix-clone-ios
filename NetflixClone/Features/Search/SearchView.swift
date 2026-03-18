import SwiftUI

struct SearchView: View {
    @State private var query = ""
    @State private var isSearching = false
    @FocusState private var isFocused: Bool

    private var results: [Movie] {
        guard !query.isEmpty else { return [] }
        return MockData.movies.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
            $0.genres.map(\.rawValue).joined().localizedCaseInsensitiveContains(query)
        }
    }

    private let columns = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4)
    ]

    var body: some View {
        VStack(spacing: 0) {
            searchBar
            if isSearching && !query.isEmpty {
                searchResults
            } else {
                categoryGrid
            }
        }
        .netflixScreen()
    }

    // MARK: Search bar
    private var searchBar: some View {
        HStack(spacing: NetflixTheme.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(NetflixTheme.Colors.textSecondary)

            TextField("", text: $query, prompt:
                Text("Search for a show, movie...").foregroundColor(NetflixTheme.Colors.textTertiary)
            )
            .foregroundColor(NetflixTheme.Colors.textPrimary)
            .font(NetflixTheme.Typography.body)
            .focused($isFocused)
            .onChange(of: query) { _, new in
                isSearching = !new.isEmpty
            }

            if !query.isEmpty {
                Button {
                    query = ""
                    isSearching = false
                    isFocused = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(NetflixTheme.Colors.textSecondary)
                }
            }
        }
        .padding(NetflixTheme.Spacing.sm)
        .background(NetflixTheme.Colors.cardBg)
        .cornerRadius(4)
        .padding(.horizontal, NetflixTheme.Spacing.md)
        .padding(.vertical, NetflixTheme.Spacing.sm)
    }

    // MARK: Category grid
    private var categoryGrid: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: NetflixTheme.Spacing.md) {
                Text("Top Searches")
                    .netflixText(.rowHeader)
                    .padding(.horizontal, NetflixTheme.Spacing.md)

                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(Genre.allCases) { genre in
                        genreCard(genre)
                    }
                }
                .padding(.horizontal, NetflixTheme.Spacing.md)
            }
            .padding(.top, NetflixTheme.Spacing.sm)
        }
    }

    private func genreCard(_ genre: Genre) -> some View {
        let colors: [Color] = [.blue, .purple, .red, .orange, .green, .teal, .pink, .indigo, .yellow, .mint]
        let color = colors[abs(genre.rawValue.hashValue) % colors.count]
        return ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color.opacity(0.7))
                .frame(height: 80)
            Text(genre.rawValue)
                .netflixText(.cardTitle)
                .padding(8)
        }
    }

    // MARK: Search results
    private var searchResults: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(results.isEmpty ? MockData.movies : results) { movie in
                    MovieCard(movie: movie, size: .medium)
                }
            }
            .padding(.horizontal, NetflixTheme.Spacing.md)
        }
    }
}

#Preview { SearchView() }
