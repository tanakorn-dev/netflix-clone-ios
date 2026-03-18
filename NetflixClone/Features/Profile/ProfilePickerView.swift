import SwiftUI

struct ProfilePickerView: View {
    @EnvironmentObject var router: AppRouter
    @State private var avatarsVisible = false
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        if router.selectedProfile != nil {
            MainTabView()
                .transition(.netflixFade)
        } else {
            VStack(spacing: NetflixTheme.Spacing.xl) {
                Spacer()

                Text("Who's watching?")
                    .netflixText(.detailTitle)
                    .opacity(avatarsVisible ? 1 : 0)

                LazyVGrid(columns: columns, spacing: NetflixTheme.Spacing.xl) {
                    ForEach(Array(Profile.samples.enumerated()), id: \.element.id) { index, profile in
                        ProfileAvatar(profile: profile, size: .medium) {
                            withAnimation(NetflixAnimation.spring) {
                                router.selectProfile(profile)
                            }
                        }
                        .opacity(avatarsVisible ? 1 : 0)
                        .scaleEffect(avatarsVisible ? 1 : 0.8)
                        .animation(
                            NetflixAnimation.spring.delay(Double(index) * 0.08),
                            value: avatarsVisible
                        )
                    }
                }
                .padding(.horizontal, NetflixTheme.Spacing.xxl)

                Spacer()

                Button("Manage Profiles") {}
                    .netflixButton(.secondary)
                    .opacity(avatarsVisible ? 1 : 0)
                    .padding(.bottom, NetflixTheme.Spacing.xl)
            }
            .netflixScreen()
            .onAppear {
                withAnimation(NetflixAnimation.spring) {
                    avatarsVisible = true
                }
            }
        }
    }
}

#Preview {
    ProfilePickerView().environmentObject(AppRouter())
}

