import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var router: AppRouter

    var body: some View {
        ZStack(alignment: .bottom) {
            NetflixTheme.Colors.background.ignoresSafeArea()

            TabView(selection: $router.selectedTab) {
                HomeView().tag(0)
                SearchView().tag(1)
                DownloadsView().tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            CustomTabBar()
        }
        .ignoresSafeArea(edges: .bottom)
        // Full-screen player overlay
        .fullScreenCover(item: $router.playerMovie) { movie in
            VideoPlayerView(movie: movie)
                .environmentObject(router)
        }
    }
}

struct CustomTabBar: View {
    @EnvironmentObject var router: AppRouter

    private let items: [(icon: String, label: String)] = [
        ("house.fill",             "Home"),
        ("magnifyingglass",        "Search"),
        ("arrow.down.circle.fill", "Downloads")
    ]

    var body: some View {
        HStack {
            ForEach(items.indices, id: \.self) { i in
                Spacer()
                Button {
                    router.switchTab(i)
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: items[i].icon)
                            .font(.system(size: router.selectedTab == i ? 24 : 22))
                            .scaleEffect(router.selectedTab == i ? 1.1 : 1.0)
                        Text(items[i].label)
                            .font(NetflixTheme.Typography.caption)
                    }
                    .foregroundColor(
                        router.selectedTab == i
                            ? NetflixTheme.Colors.tabActive
                            : NetflixTheme.Colors.tabInactive
                    )
                    .animation(NetflixAnimation.tabBounce, value: router.selectedTab)
                }
                Spacer()
            }
        }
        .frame(height: NetflixTheme.Spacing.tabBarHeight + 20)
        .background(
            NetflixTheme.Colors.background
                .opacity(0.95)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

#Preview {
    MainTabView().environmentObject(AppRouter())
}

