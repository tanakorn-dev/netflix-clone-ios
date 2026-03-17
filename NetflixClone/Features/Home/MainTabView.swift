import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            NetflixTheme.Colors.background.ignoresSafeArea()

            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                SearchView()
                    .tag(1)
                DownloadsView()
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Custom Tab Bar — will be built in Phase 3
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    private let items: [(icon: String, label: String)] = [
        ("house.fill",       "Home"),
        ("magnifyingglass",  "Search"),
        ("arrow.down.circle.fill", "Downloads")
    ]

    var body: some View {
        HStack {
            ForEach(items.indices, id: \.self) { i in
                Spacer()
                Button {
                    selectedTab = i
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: items[i].icon)
                            .font(.system(size: 22))
                        Text(items[i].label)
                            .font(NetflixTheme.Typography.caption)
                    }
                    .foregroundColor(selectedTab == i
                        ? NetflixTheme.Colors.tabActive
                        : NetflixTheme.Colors.tabInactive)
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

#Preview { MainTabView() }
