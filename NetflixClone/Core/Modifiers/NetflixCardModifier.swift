import SwiftUI

// MARK: - Card Modifier
// Usage: Image(...).netflixCard()
//        Image(...).netflixCard(width: 160, height: 240)

struct NetflixCardModifier: ViewModifier {
    var width: CGFloat
    var height: CGFloat
    var isHighlighted: Bool

    func body(content: Content) -> some View {
        content
            .frame(width: width, height: height)
            .background(NetflixTheme.Colors.cardBg)
            .cornerRadius(NetflixTheme.Spacing.cardRadius)
            .overlay(
                RoundedRectangle(cornerRadius: NetflixTheme.Spacing.cardRadius)
                    .stroke(NetflixTheme.Colors.netflixRed,
                            lineWidth: isHighlighted ? 2 : 0)
            )
            .scaleEffect(isHighlighted ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHighlighted)
    }
}

extension View {
    func netflixCard(
        width: CGFloat = NetflixTheme.Spacing.cardWidth,
        height: CGFloat = NetflixTheme.Spacing.cardHeight,
        isHighlighted: Bool = false
    ) -> some View {
        modifier(NetflixCardModifier(width: width, height: height, isHighlighted: isHighlighted))
    }
}

// MARK: - Button Modifier
enum NetflixButtonStyle {
    case primary    // White bg, black text — Play button
    case secondary  // Dark bg, white text — More Info
    case icon       // Icon only, no bg
}

struct NetflixButtonModifier: ViewModifier {
    let style: NetflixButtonStyle

    func body(content: Content) -> some View {
        content
            .font(NetflixTheme.Typography.buttonText)
            .foregroundColor(foregroundColor)
            .padding(.horizontal, NetflixTheme.Spacing.md)
            .padding(.vertical, NetflixTheme.Spacing.sm)
            .background(backgroundColor)
            .cornerRadius(4)
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
        case .primary:   return NetflixTheme.Colors.buttonPrimary
        case .secondary: return NetflixTheme.Colors.buttonSecondary
        case .icon:      return .clear
        }
    }
}

extension View {
    func netflixButton(_ style: NetflixButtonStyle = .primary) -> some View {
        modifier(NetflixButtonModifier(style: style))
    }
}
