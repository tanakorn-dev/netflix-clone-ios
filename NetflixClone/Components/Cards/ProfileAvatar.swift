import SwiftUI

// MARK: - Profile Avatar
// Usage:
//   ProfileAvatar(profile: profile)
//   ProfileAvatar(profile: profile, size: .large)

struct ProfileAvatar: View {
    enum Size {
        case small   // 60pt — top nav
        case medium  // 80pt — profile picker
        case large   // 100pt — profile management

        var dimension: CGFloat {
            switch self { case .small: 60; case .medium: 80; case .large: 100 }
        }
        var fontSize: CGFloat {
            switch self { case .small: 11; case .medium: 13; case .large: 15 }
        }
    }

    let profile: Profile
    var size: Size = .medium
    var showName: Bool = true
    var onTap: (() -> Void)? = nil

    var body: some View {
        Button { onTap?() } label: {
            VStack(spacing: NetflixTheme.Spacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(profile.avatarColor)
                        .frame(width: size.dimension, height: size.dimension)

                    // Lock icon overlay
                    if profile.isLocked {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.black.opacity(0.5))
                            .frame(width: size.dimension, height: size.dimension)
                        Image(systemName: "lock.fill")
                            .foregroundColor(NetflixTheme.Colors.textPrimary)
                            .font(.system(size: size.dimension * 0.3))
                    }

                    // Kids badge
                    if profile.isKidsProfile {
                        Text("KIDS")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(NetflixTheme.Colors.netflixRed)
                            .cornerRadius(2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                            .padding(4)
                    }
                }

                if showName {
                    Text(profile.name)
                        .font(.system(size: size.fontSize))
                        .foregroundColor(NetflixTheme.Colors.textSecondary)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    HStack(spacing: 24) {
        ForEach(Profile.samples) { profile in
            ProfileAvatar(profile: profile)
        }
    }
    .padding()
    .netflixScreen()
}
