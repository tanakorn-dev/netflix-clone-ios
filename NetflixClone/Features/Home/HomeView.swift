import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: AppRouter
    @State private var scrollOffset: CGFloat = 0
    @State private var selectedCategory: TopNavBar.Category = .home
    @State private var heroIndex: Int = 0

    // Auto-cycle hero every 6s
    private let heroTimer = Timer.publish(every: 6, on: .main, in: .common).autoconnect()
    private var heroMovies: [Movie] { Array(MockData.movies.prefix(4)) }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    GeometryReader { geo in
                        Color.clear.preference(
                            key: ScrollOffsetKey.self,
                            value: -geo.frame(in: .named("scroll")).minY
                        )
                    }
                    .frame(height: 0)

                    // Auto-cycling hero banner
                    ZStack {
                        ForEach(heroMovies.indices, id: \.self) { i in
                            HeroBanner(movie: heroMovies[i]) {
                                router.playMovie(heroMovies[i])
                            } onMoreInfo: { movie in
                                router.showDetail(movie)
                            }
                            .opacity(heroIndex == i ? 1 : 0)
                            .animation(NetflixAnimation.heroSlide, value: heroIndex)
                        }
                    }

                    // Page dots for hero
                    heroDots
                        .padding(.top, -NetflixTheme.Spacing.lg)
                        .padding(.bottom, NetflixTheme.Spacing.sm)

                    // Content rows
                    ForEach(filteredRows) { row in
                        ContentRowView(row: row) { movie in
                            router.showDetail(movie)
                        }
                        .padding(.top, NetflixTheme.Spacing.rowGap)
                    }

                    Spacer().frame(height: 100)
                }
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetKey.self) { scrollOffset = $0 }
            .onReceive(heroTimer) { _ in
                heroIndex = (heroIndex + 1) % heroMovies.count
            }

            // Overlay nav bar
            TopNavBar(
                scrollOffset: $scrollOffset,
                selectedCategory: $selectedCategory
            )
        }
        .netflixScreen()
        // Detail sheet
        .sheet(item: $router.detailMovie) { movie in
            MovieDetailView(movie: movie)
                .environmentObject(router)
        }
    }

    // Filter rows by selected category
    private var filteredRows: [ContentRow] {
        switch selectedCategory {
        case .tvShows:
            return MockData.homeRows.filter {
                $0.movies.contains { $0.duration.contains("Season") }
            }
        case .movies:
            return MockData.homeRows.filter {
                $0.movies.contains { !$0.duration.contains("Season") }
            }
        case .myList:
            return [ContentRow(title: "My List", movies: Array(MockData.movies.prefix(3)))]
        default:
            return MockData.homeRows
        }
    }

    // Hero page dots
    private var heroDots: some View {
        HStack(spacing: 6) {
            ForEach(heroMovies.indices, id: \.self) { i in
                Circle()
                    .fill(i == heroIndex
                          ? NetflixTheme.Colors.textPrimary
                          : NetflixTheme.Colors.textTertiary)
                    .frame(width: i == heroIndex ? 8 : 5,
                           height: i == heroIndex ? 8 : 5)
                    .animation(NetflixAnimation.snappy, value: heroIndex)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    HomeView().environmentObject(AppRouter())
}

