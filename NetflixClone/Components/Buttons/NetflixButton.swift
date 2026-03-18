import SwiftUI

// MARK: - Netflix Button
// Usage:
//   NetflixButton(title: "▶  Play", style: .primary) { }
//   NetflixButton(title: "ⓘ  More Info", style: .secondary) { }
//   NetflixButton(icon: "plus", label: "My List", style: .icon) { }

struct NetflixButton: View {
    enum Style { case primary, secondary, icon }

    var title: String?
    var icon: String?
    var label: String?
    var style: Style = .primary
    var isFullWidth: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: NetflixTheme.Spacing.xs) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: style == .icon ? 20 : 16, weight: .medium))
                }
                if let title {
                    Text(title)
                        .font(NetflixTheme.Typography.buttonText)
                }
                if let label {
                    Text(label)
                        .font(NetflixTheme.Typography.caption)
                        .foregroundColor(NetflixTheme.Colors.textSecondary)
                }
            }
            .foregroundColor(foregroundColor)
            .padding(.horizontal, style == .icon ? NetflixTheme.Spacing.sm : NetflixTheme.Spacing.md)
            .padding(.vertical, NetflixTheme.Spacing.sm)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .background(backgroundColor)
            .cornerRadius(4)
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary:   return .black
        case .secondary: return NetflixTheme.Colors.textPrimary
        case .icon:      return NetflixTheme.Colors.textPrimary
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .primary:   return .white
        case .secondary: return NetflixTheme.Colors.buttonSecondary
        case .icon:      return .clear
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        NetflixButton(title: "▶  Play", style: .primary, isFullWidth: true) {}
        NetflixButton(title: "ⓘ  More Info", style: .secondary, isFullWidth: true) {}
        HStack(spacing: 24) {
            NetflixButton(icon: "plus", label: "My List", style: .icon) {}
            NetflixButton(icon: "hand.thumbsup", label: "Rate", style: .icon) {}
            NetflixButton(icon: "paperplane", label: "Share", style: .icon) {}
        }
    }
    .padding()
    .netflixScreen()
}
