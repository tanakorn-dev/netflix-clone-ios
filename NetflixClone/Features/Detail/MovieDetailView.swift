import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @EnvironmentObject var router: AppRouter
    @Environment(\.dismiss) private var dismiss
    @State private var contentVisible = false

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    backdropSection
                    infoSection
                        .padding(.horizontal, NetflixTheme.Spacing.md)
                        .opacity(contentVisible ? 1 : 0)
                        .offset(y: contentVisible ? 0 : 16)
                    actionButtons
                        .padding(.horizontal, NetflixTheme.Spacing.md)
                        .opacity(contentVisible ? 1 : 0)
                        .offset(y: contentVisible ? 0 : 16)
                    descriptionSection
                        .padding(.horizontal, NetflixTheme.Spacing.md)
                        .opacity(contentVisible ? 1 : 0)
                    castSection
                        .padding(.horizontal, NetflixTheme.Spacing.md)
                        .opacity(contentVisible ? 1 : 0)
                    moreLikeThis
                        .opacity(contentVisible ? 1 : 0)
                    Spacer().frame(height: 40)
                }
            }
            .netflixScreen()
            .onAppear {
                withAnimation(NetflixAnimation.spring.delay(0.15)) {
                    contentVisible = true
                }
            }

            // Close button
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(NetflixTheme.Colors.textPrimary)
                    .padding(10)
                    .background(NetflixTheme.Colors.cardBg.opacity(0.9))
                    .clipShape(Circle())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding([.top, .trailing], NetflixTheme.Spacing.md)
        }
    }

    private var backdropSection: some View {
        ZStack(alignment: .bottom) {
            PosterImage(
                url: movie.backdropURL,
                contentMode: .fill,
                width: UIScreen.main.bounds.width,
                height: 280,
                cornerRadius: 0
            )
            LinearGradient(
                colors: [.clear, NetflixTheme.Colors.background],
                startPoint: .center, endPoint: .bottom
            )
            if movie.isNetflixOriginal {
                BadgeLabel(text: "N  S E R I E S", style: .netflixOriginal)
                    .padding(.bottom, NetflixTheme.Spacing.sm)
            }
        }
        .frame(height: 280)
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: NetflixTheme.Spacing.sm) {
            Text(movie.title).netflixText(.detailTitle)
            HStack(spacing: NetflixTheme.Spacing.sm) {
                BadgeLabel(text: "\(movie.matchPercentage)% Match", style: .match)
                Text(String(movie.year)).netflixText(.caption)
                BadgeLabel(text: movie.rating, style: .rating)
                Text(movie.duration).netflixText(.caption)
            }
        }
        .padding(.top, NetflixTheme.Spacing.sm)
    }

    private var actionButtons: some View {
        VStack(spacing: NetflixTheme.Spacing.sm) {
            NetflixButton(title: "▶  Play", style: .primary, isFullWidth: true) {
                router.playMovie(movie)
            }
            NetflixButton(title: "⬇  Download", style: .secondary, isFullWidth: true) {}
            HStack(spacing: NetflixTheme.Spacing.xl) {
                NetflixButton(icon: "plus",           label: "My List", style: .icon) {}
                NetflixButton(icon: "hand.thumbsup",  label: "Rate",    style: .icon) {}
                NetflixButton(icon: "paperplane",     label: "Share",   style: .icon) {}
                Spacer()
            }
            .padding(.top, NetflixTheme.Spacing.xs)
        }
        .padding(.top, NetflixTheme.Spacing.md)
    }

    private var descriptionSection: some View {
        Text(movie.description)
            .netflixText(.body)
            .lineSpacing(4)
            .padding(.top, NetflixTheme.Spacing.md)
    }

    private var castSection: some View {
        VStack(alignment: .leading, spacing: NetflixTheme.Spacing.xs) {
            HStack {
                Text("Cast: ").netflixText(.caption)
                Text(movie.cast.joined(separator: ", ")).netflixText(.caption)
            }
            HStack {
                Text("Genres: ").netflixText(.caption)
                Text(movie.genres.map(\.rawValue).joined(separator: ", ")).netflixText(.caption)
            }
        }
        .padding(.top, NetflixTheme.Spacing.md)
    }

    private var moreLikeThis: some View {
        ContentRowView(
            row: ContentRow(title: "More Like This", movies: MockData.movies.shuffled()),
            cardSize: .medium
        ) { movie in
            router.showDetail(movie)
        }
        .padding(.top, NetflixTheme.Spacing.xl)
    }
}

#Preview {
    MovieDetailView(movie: MockData.heroMovie)
        .environmentObject(AppRouter())
}

