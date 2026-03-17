import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            NetflixTheme.Colors.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // TODO: Phase 3 — HeroBannerComponent
                    Rectangle()
                        .fill(NetflixTheme.Colors.cardBg)
                        .frame(height: NetflixTheme.Spacing.heroHeight)
                        .overlay(
                            Text("Hero Banner")
                                .foregroundColor(NetflixTheme.Colors.textSecondary)
                        )

                    // TODO: Phase 3 — ContentRow components
                    ForEach(MockData.homeRows) { row in
                        VStack(alignment: .leading, spacing: NetflixTheme.Spacing.sm) {
                            Text(row.title)
                                .font(NetflixTheme.Typography.rowHeader)
                                .foregroundColor(NetflixTheme.Colors.textPrimary)
                                .padding(.horizontal, NetflixTheme.Spacing.rowPaddingH)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: NetflixTheme.Spacing.cardGap) {
                                    ForEach(row.movies) { movie in
                                        // TODO: Phase 3 — MovieCard component
                                        RoundedRectangle(cornerRadius: NetflixTheme.Spacing.cardRadius)
                                            .fill(NetflixTheme.Colors.cardBg)
                                            .frame(width: NetflixTheme.Spacing.cardWidth,
                                                   height: NetflixTheme.Spacing.cardHeight)
                                            .overlay(
                                                Text(movie.title)
                                                    .font(NetflixTheme.Typography.caption)
                                                    .foregroundColor(NetflixTheme.Colors.textSecondary)
                                                    .multilineTextAlignment(.center)
                                                    .padding(4)
                                            )
                                    }
                                }
                                .padding(.horizontal, NetflixTheme.Spacing.rowPaddingH)
                            }
                        }
                        .padding(.top, NetflixTheme.Spacing.rowGap)
                    }

                    Spacer().frame(height: 80)
                }
            }
        }
    }
}

#Preview { HomeView() }
