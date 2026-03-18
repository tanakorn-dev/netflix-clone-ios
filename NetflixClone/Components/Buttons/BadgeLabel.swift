import SwiftUI

// MARK: - Badge Label
// Usage:
//   BadgeLabel(text: "98% Match", style: .match)
//   BadgeLabel(text: "TV-MA", style: .rating)
//   BadgeLabel(text: "N", style: .netflixOriginal)
//   BadgeLabel(text: "NEW", style: .new)

struct BadgeLabel: View {
    enum Style {
        case match
        case rating
        case netflixOriginal
        case new
    }

    let text: String
    let style: Style

    var body: some View {
        Text(text)
            .font(font)
            .foregroundColor(foregroundColor)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, 2)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
    }

    private var font: Font {
        switch style {
        case .netflixOriginal: return .system(size: 13, weight: .black)
        case .match:           return NetflixTheme.Typography.matchPct
        default:               return NetflixTheme.Typography.caption
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .match:           return NetflixTheme.Colors.matchGreen
        case .netflixOriginal: return NetflixTheme.Colors.netflixRed
        case .new:             return .black
        default:               return NetflixTheme.Colors.textSecondary
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .new:  return NetflixTheme.Colors.matchGreen
        default:    return .clear
        }
    }

    private var borderColor: Color {
        switch style {
        case .rating: return NetflixTheme.Colors.textSecondary
        default:      return .clear
        }
    }

    private var borderWidth: CGFloat {
        style == .rating ? 0.8 : 0
    }

    private var horizontalPadding: CGFloat {
        switch style {
        case .rating: return 4
        case .new:    return 4
        default:      return 0
        }
    }

    private var cornerRadius: CGFloat {
        style == .rating ? 2 : 0
    }
}

// MARK: - Preview
#Preview {
    HStack(spacing: 12) {
        BadgeLabel(text: "98% Match", style: .match)
        BadgeLabel(text: "TV-MA", style: .rating)
        BadgeLabel(text: "N", style: .netflixOriginal)
        BadgeLabel(text: "NEW", style: .new)
    }
    .padding()
    .netflixScreen()
}
