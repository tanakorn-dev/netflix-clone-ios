import SwiftUI

struct ProfilePickerView: View {
    @State private var selectedProfile: Profile?
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        if selectedProfile != nil {
            MainTabView()
        } else {
            ZStack {
                NetflixTheme.Colors.background.ignoresSafeArea()
                VStack(spacing: NetflixTheme.Spacing.xl) {
                    Text("Who's watching?")
                        .font(NetflixTheme.Typography.detailTitle)
                        .foregroundColor(NetflixTheme.Colors.textPrimary)

                    LazyVGrid(columns: columns, spacing: NetflixTheme.Spacing.lg) {
                        ForEach(Profile.samples) { profile in
                            Button {
                                selectedProfile = profile
                            } label: {
                                VStack(spacing: NetflixTheme.Spacing.sm) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(profile.avatarColor)
                                        .frame(width: 80, height: 80)
                                    Text(profile.name)
                                        .font(NetflixTheme.Typography.body)
                                        .foregroundColor(NetflixTheme.Colors.textSecondary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, NetflixTheme.Spacing.xl)
                }
            }
        }
    }
}

#Preview { ProfilePickerView() }
