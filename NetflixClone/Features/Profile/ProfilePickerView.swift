import SwiftUI

struct ProfilePickerView: View {
    @EnvironmentObject var router: AppRouter
    @State private var avatarsVisible = false
    @State private var backdropIndex: Int = 0
    @State private var backdropOpacity: Double = 1.0

    private let backdropMovies = MockData.backdropMovies
    private let backdropTimer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        if router.selectedProfile != nil {
            MainTabView()
                .transition(.netflixFade)
        } else {
            ZStack {
                backdropImage

                // Bottom gradient overlay
                VStack(spacing: 0) {
                    Spacer()
                    LinearGradient(
                        colors: [.clear, Color.black.opacity(0.85), Color.black],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 480)
                }
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()
                    pickerContent
                }
                .ignoresSafeArea(edges: .bottom)
            }
            .onAppear {
                withAnimation(NetflixAnimation.spring) {
                    avatarsVisible = true
                }
            }
            .onReceive(backdropTimer) { _ in
                cycleBackdrop()
            }
        }
    }

    // MARK: - Backdrop
    private var backdropImage: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if !backdropMovies.isEmpty {
                let movie = backdropMovies[backdropIndex]
                AsyncImage(url: URL(string: movie.backdropURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure, .empty:
                        Color(hex: "1a1a2e")
                    @unknown default:
                        Color(hex: "1a1a2e")
                    }
                }
                .ignoresSafeArea()
                .opacity(backdropOpacity)
                .animation(.easeInOut(duration: 0.8), value: backdropOpacity)
            }
        }
    }

    // MARK: - Cycle logic
    private func cycleBackdrop() {
        guard backdropMovies.count > 1 else { return }
        withAnimation(.easeInOut(duration: 0.8)) {
            backdropOpacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            backdropIndex = (backdropIndex + 1) % backdropMovies.count
            withAnimation(.easeInOut(duration: 0.8)) {
                backdropOpacity = 1
            }
        }
    }

    // MARK: - Picker content
    private var pickerContent: some View {
        VStack(spacing: NetflixTheme.Spacing.lg) {
            Text("Choose Your Profile")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(NetflixTheme.Colors.textSecondary)
                .opacity(avatarsVisible ? 1 : 0)

            LazyVGrid(columns: columns, spacing: NetflixTheme.Spacing.lg) {
                ForEach(Array(Profile.samples.prefix(3).enumerated()), id: \.element.id) { index, profile in
                    profileCell(profile: profile, index: index)
                }
            }
            .padding(.horizontal, NetflixTheme.Spacing.xl)

            LazyVGrid(columns: columns, spacing: NetflixTheme.Spacing.lg) {
                if Profile.samples.count > 3 {
                    profileCell(profile: Profile.samples[3], index: 3)
                }
                actionCell(icon: "plus",   label: "Add")  {}
                actionCell(icon: "pencil", label: "Edit") {}
            }
            .padding(.horizontal, NetflixTheme.Spacing.xl)
        }
        .padding(.bottom, 52)
        .padding(.top, NetflixTheme.Spacing.md)
    }

    // MARK: - Profile cell
    private func profileCell(profile: Profile, index: Int) -> some View {
        Button {
            withAnimation(NetflixAnimation.spring) {
                router.selectProfile(profile)
            }
        } label: {
            VStack(spacing: NetflixTheme.Spacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(profile.avatarColor)
                        .aspectRatio(1, contentMode: .fit)

                    profileIcon(for: profile)

                    if profile.isLocked {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.55))
                        Image(systemName: "lock.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                    }

                    if profile.isKidsProfile {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("KIDS")
                                    .font(.system(size: 8, weight: .black))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(NetflixTheme.Colors.netflixRed)
                                    .cornerRadius(2)
                                    .padding(6)
                            }
                        }
                    }
                }

                Text(profile.name)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(NetflixTheme.Colors.textSecondary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
        .opacity(avatarsVisible ? 1 : 0)
        .scaleEffect(avatarsVisible ? 1 : 0.85)
        .animation(
            NetflixAnimation.spring.delay(Double(index) * 0.07),
            value: avatarsVisible
        )
    }

    // MARK: - Add / Edit cell
    private func actionCell(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: NetflixTheme.Spacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.12))
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .light))
                        .foregroundColor(NetflixTheme.Colors.textPrimary)
                }
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(NetflixTheme.Colors.textSecondary)
            }
        }
        .buttonStyle(.plain)
        .opacity(avatarsVisible ? 1 : 0)
        .animation(NetflixAnimation.spring.delay(0.28), value: avatarsVisible)
    }

    // MARK: - Profile icon
    @ViewBuilder
    private func profileIcon(for profile: Profile) -> some View {
        switch profile.name {
        case "Tanakorn":
            Image(systemName: "person.fill")
                .font(.system(size: 36))
                .foregroundColor(.white.opacity(0.9))
        case "Aummy":
            Image(systemName: "face.smiling.fill")
                .font(.system(size: 34))
                .foregroundColor(.white.opacity(0.9))
        case "Bill":
            Image(systemName: "theatermasks.fill")
                .font(.system(size: 32))
                .foregroundColor(.white.opacity(0.9))
        case "Sakda":
            Image(systemName: "star.fill")
                .font(.system(size: 32))
                .foregroundColor(.white.opacity(0.9))
        default:
            Image(systemName: "person.fill")
                .font(.system(size: 36))
                .foregroundColor(.white.opacity(0.9))
        }
    }
}

#Preview {
    ProfilePickerView().environmentObject(AppRouter())
}
