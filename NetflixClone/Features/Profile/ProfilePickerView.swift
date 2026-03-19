import SwiftUI

struct ProfilePickerView: View {
    @EnvironmentObject var router: AppRouter
    @State private var avatarsVisible = false
    @State private var backdropIndex: Int = 0
    @State private var backdropNextIndex: Int = 1
    @State private var backdropCrossfadeOpacity: Double = 0.0

    private let backdropMovies = MockData.backdropMovies
    private let backdropTimer = Timer.publish(every: 8, on: .main, in: .common).autoconnect()

    var body: some View {
        if router.selectedProfile != nil {
            MainTabView()
                .transition(.netflixFade)
        } else {
            ZStack(alignment: .bottom) {
                backdropLayer
                pickerContent
            }
            .onAppear {
                withAnimation(NetflixAnimation.spring) { avatarsVisible = true }
                backdropNextIndex = (backdropMovies.count > 1) ? 1 : 0
            }
            .onReceive(backdropTimer) { _ in cycleBackdrop() }
        }
    }

    // MARK: - Backdrop layer
    private var backdropLayer: some View {
        GeometryReader { geo in
            let backdropHeight = geo.size.height * 0.75

            ZStack {
                Color.black

                // Crossfade images
                backdropImages
                    .frame(width: geo.size.width, height: backdropHeight)
                    .clipped()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                // Fade-to-black gradient
                LinearGradient(
                    colors: [.clear, Color.black.opacity(0.75), Color.black],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: backdropHeight * 0.55)
                .offset(y: backdropHeight * 0.45)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                // Movie logo
                if !backdropMovies.isEmpty {
                    movieLogoOverlay(geo: geo)
                }
            }
        }
        .ignoresSafeArea()
    }

    private var backdropImages: some View {
        ZStack {
            Color(hex: "1a1a2e")
            if !backdropMovies.isEmpty {
                CachedAsyncImage(url: backdropMovies[backdropIndex].backdropURL, contentMode: .fill)
                CachedAsyncImage(url: backdropMovies[backdropNextIndex].backdropURL, contentMode: .fill)
                    .opacity(backdropCrossfadeOpacity)
            }
        }
    }

    private func movieLogoOverlay(geo: GeometryProxy) -> some View {
        let current = backdropMovies[backdropIndex]
        let next = backdropMovies[backdropNextIndex]
        return ZStack {
            if !current.logoURL.isEmpty {
                CachedAsyncImage(url: current.logoURL, contentMode: .fit, showFallback: false)
                    .frame(maxWidth: geo.size.width * 0.65)
                    .opacity(1 - backdropCrossfadeOpacity)
            }
            if !next.logoURL.isEmpty {
                CachedAsyncImage(url: next.logoURL, contentMode: .fit, showFallback: false)
                    .frame(maxWidth: geo.size.width * 0.65)
                    .opacity(backdropCrossfadeOpacity)
            }
        }
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .position(x: geo.size.width / 2, y: geo.size.height * 0.55)
    }

    // MARK: - Backdrop cycle
    private func cycleBackdrop() {
        guard backdropMovies.count > 1 else { return }
        backdropNextIndex = (backdropIndex + 1) % backdropMovies.count
        backdropCrossfadeOpacity = 0
        withAnimation(.easeInOut(duration: 1.2)) { backdropCrossfadeOpacity = 1.0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            backdropIndex = backdropNextIndex
            backdropCrossfadeOpacity = 0
        }
    }

    // MARK: - Picker content
    private var pickerContent: some View {
        GeometryReader { geo in
            let cellSize: CGFloat = 80
            let gap = (geo.size.width - cellSize * 3) / 4

            VStack(spacing: gap * 0.5) {
                Text("Choose Your Profile")
                    .font(NetflixTheme.Typography.medium(17))
                    .foregroundColor(NetflixTheme.Colors.textSecondary)
                    .opacity(avatarsVisible ? 1 : 0)
                    .padding(.bottom, 10 - gap * 0.5)

                HStack(spacing: gap) {
                    ForEach(Array(Profile.samples.prefix(3).enumerated()), id: \.element.id) { index, profile in
                        profileCell(profile: profile, index: index, size: cellSize)
                    }
                }
                .padding(.horizontal, gap)

                HStack(spacing: gap) {
                    if Profile.samples.count > 3 {
                        profileCell(profile: Profile.samples[3], index: 3, size: cellSize)
                    }
                    actionCell(icon: "plus",   label: "Add",  size: cellSize) {}
                    actionCell(icon: "pencil", label: "Edit", size: cellSize) {}
                }
                .padding(.horizontal, gap)
            }
            .frame(width: geo.size.width, alignment: .bottom)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(height: 300)
    }

    // MARK: - Profile cell
    private func profileCell(profile: Profile, index: Int, size: CGFloat) -> some View {
        Button {
            withAnimation(NetflixAnimation.spring) { router.selectProfile(profile) }
        } label: {
            VStack(spacing: NetflixTheme.Spacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: size * 0.16)
                        .fill(profile.avatarColor)
                        .frame(width: size, height: size)
                    profileIcon(for: profile, size: size)
                    if profile.isLocked {
                        RoundedRectangle(cornerRadius: size * 0.16)
                            .fill(Color.black.opacity(0.55))
                            .frame(width: size, height: size)
                        Image(systemName: "lock.fill")
                            .font(.system(size: size * 0.2))
                            .foregroundColor(.white)
                    }
                    if profile.isKidsProfile {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("KIDS")
                                    .font(NetflixTheme.Typography.black(max(size * 0.05, 8)))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 4).padding(.vertical, 2)
                                    .background(NetflixTheme.Colors.netflixRed)
                                    .cornerRadius(2).padding(6)
                            }
                        }
                        .frame(width: size, height: size)
                    }
                }
                .frame(width: size, height: size)
                Text(profile.name)
                    .font(NetflixTheme.Typography.bold(13))
                    .foregroundColor(NetflixTheme.Colors.textSecondary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
        .opacity(avatarsVisible ? 1 : 0)
        .scaleEffect(avatarsVisible ? 1 : 0.85)
        .animation(NetflixAnimation.spring.delay(Double(index) * 0.07), value: avatarsVisible)
    }

    // MARK: - Action cell
    private func actionCell(icon: String, label: String, size: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: NetflixTheme.Spacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: size * 0.16)
                        .fill(Color.white.opacity(0.12))
                        .frame(width: size, height: size)
                        .overlay(RoundedRectangle(cornerRadius: size * 0.16)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1))
                    Image(systemName: icon)
                        .font(.system(size: size * 0.3, weight: .light))
                        .foregroundColor(NetflixTheme.Colors.textPrimary)
                }
                .frame(width: size, height: size)
                Text(label)
                    .font(NetflixTheme.Typography.medium(13))
                    .foregroundColor(NetflixTheme.Colors.textSecondary)
            }
        }
        .buttonStyle(.plain)
        .opacity(avatarsVisible ? 1 : 0)
        .animation(NetflixAnimation.spring.delay(0.28), value: avatarsVisible)
    }

    // MARK: - Profile icon
    @ViewBuilder
    private func profileIcon(for profile: Profile, size: CGFloat) -> some View {
        let iconSize = size * 0.4
        let systemName: String = {
            switch profile.name {
            case "Tanakorn": return "person.fill"
            case "Aummy":    return "face.smiling.fill"
            case "Bill":     return "theatermasks.fill"
            case "Sakda":    return "star.fill"
            default:         return "person.fill"
            }
        }()
        let scale: CGFloat = ["Bill", "Sakda"].contains(profile.name) ? 0.9 : 1.0
        Image(systemName: systemName)
            .font(.system(size: iconSize * scale))
            .foregroundColor(.white.opacity(0.9))
    }
}

#Preview {
    ProfilePickerView().environmentObject(AppRouter())
}
