import SwiftUI

// MARK: - Typography Modifiers
// Usage: Text("Trending Now").modifier(NetflixTextStyle(.rowHeader))
// Or via extension: Text("...").netflixText(.rowHeader)

struct NetflixTextStyle: ViewModifier {

    enum Style {
        case heroTitle
        case rowHeader
        case cardTitle
        case body
        case caption
        case buttonText
        case navItem
        case detailTitle
        case matchPercentage
    }

    let style: Style

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
    }

    private var font: Font {
        switch style {
        case .heroTitle:       return NetflixTheme.Typography.heroTitle
        case .rowHeader:       return NetflixTheme.Typography.rowHeader
        case .cardTitle:       return NetflixTheme.Typography.cardTitle
        case .body:            return NetflixTheme.Typography.body
        case .caption:         return NetflixTheme.Typography.caption
        case .buttonText:      return NetflixTheme.Typography.buttonText
        case .navItem:         return NetflixTheme.Typography.navItem
        case .detailTitle:     return NetflixTheme.Typography.detailTitle
        case .matchPercentage: return NetflixTheme.Typography.matchPct
        }
    }

    private var color: Color {
        switch style {
        case .caption, .navItem:     return NetflixTheme.Colors.textSecondary
        case .matchPercentage:       return NetflixTheme.Colors.matchGreen
        default:                     return NetflixTheme.Colors.textPrimary
        }
    }
}

extension View {
    func netflixText(_ style: NetflixTextStyle.Style) -> some View {
        modifier(NetflixTextStyle(style: style))
    }
}
