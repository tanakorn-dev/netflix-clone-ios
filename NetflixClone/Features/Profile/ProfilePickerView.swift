import SwiftUI

struct ProfilePickerView: View {
    @EnvironmentObject var router: AppRouter
    @State private var avatarsVisible = false
    @State private var backdropIndex: Int = 0
    @State private var backdropOpacity: Double = 1.0

    private let backdropMovies = MockData.backdropMovies
    private let backdropTimer = Timer.publish(every: 8, on: .main, in: .common).autoconnect()

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
            ZStack(alignment: .bottom) {
                // Layer 1: Backdrop + gradient — full screen canvas
                GeometryReader { geo in
                    let backdropHeight = geo.size.height * 0.75

                    ZStack {
                        Color.black

                        // Backdrop anchored to top, 80% height
                        backdropImage
                            .frame(width: geo.size.width, height: backdropHeight)
                            .clipped()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                        // Gradient fading into black at bottom of backdrop
                        LinearGradient(
                            colors: [.clear, Color.black.opacity(0.75), Color.black],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: backdropHeight * 0.55)
                        .offset(y: backdropHeight * 0.45)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
                }
                .ignoresSafeArea()

                // Layer 2: Profile picker — free-floating, pinned to bottom, never clipped
                pickerContent
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
            Color(hex: "1a1a2e")

            if !backdropMovies.isEmpty {
                let movie = backdropMovies[backdropIndex]
                CachedAsyncImage(
                    url: movie.backdropURL,
                    contentMode: .fill
                )
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
        GeometryReader { geo in
            let cellSize: CGFloat = 80
            let gap = (geo.size.width - cellSize * 3) / 4  // equal gaps: left | cell | gap | cell | gap | cell | right

            VStack(spacing: gap * 0.5) {
                Text("Choose Your Profile")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(NetflixTheme.Colors.textSecondary)
                    .opacity(avatarsVisible ? 1 : 0)
                    .padding(.bottom, 10 - gap * 0.5)

                // Row 1
                HStack(spacing: gap) {
                    ForEach(Array(Profile.samples.prefix(3).enumerated()), id: \.element.id) { index, profile in
                        profileCell(profile: profile, index: index, size: cellSize)
                    }
                }
                .padding(.horizontal, gap)

                // Row 2
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
            .padding(.bottom, 0)
        }
        .frame(height: 300)
    }

    // MARK: - Profile cell
    private func profileCell(profile: Profile, index: Int, size: CGFloat) -> some View {
        Button {
            withAnimation(NetflixAnimation.spring) {
                router.selectProfile(profile)
            }
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
                                    .font(.system(size: max(size * 0.05, 8), weight: .black))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(NetflixTheme.Colors.netflixRed)
                                    .cornerRadius(2)
                                    .padding(6)
                            }
                        }
                        .frame(width: size, height: size)
                    }
                }
                .frame(width: size, height: size)

                Text(profile.name)
                    .font(.system(size: 13, weight: .bold))
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
    private func actionCell(icon: String, label: String, size: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: NetflixTheme.Spacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: size * 0.16)
                        .fill(Color.white.opacity(0.12))
                        .frame(width: size, height: size)
                        .overlay(
                            RoundedRectangle(cornerRadius: size * 0.16)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                    Image(systemName: icon)
                        .font(.system(size: size * 0.3, weight: .light))
                        .foregroundColor(NetflixTheme.Colors.textPrimary)
                }
                .frame(width: size, height: size)
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
    private func profileIcon(for profile: Profile, size: CGFloat) -> some View {
        let iconSize = size * 0.4
        switch profile.name {
        case "Tanakorn":
            Image(systemName: "person.fill")
                .font(.system(size: iconSize))
                .foregroundColor(.white.opacity(0.9))
        case "Aummy":
            Image(systemName: "face.smiling.fill")
                .font(.system(size: iconSize))
                .foregroundColor(.white.opacity(0.9))
        case "Bill":
            Image(systemName: "theatermasks.fill")
                .font(.system(size: iconSize * 0.9))
                .foregroundColor(.white.opacity(0.9))
        case "Sakda":
            Image(systemName: "star.fill")
                .font(.system(size: iconSize * 0.9))
                .foregroundColor(.white.opacity(0.9))
        default:
            Image(systemName: "person.fill")
                .font(.system(size: iconSize))
                .foregroundColor(.white.opacity(0.9))
        }
    }
}

#Preview {
    ProfilePickerView().environmentObject(AppRouter())
}
