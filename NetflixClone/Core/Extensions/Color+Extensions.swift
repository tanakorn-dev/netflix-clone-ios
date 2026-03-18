import SwiftUI

extension Color {

    // MARK: - Opacity shorthand
    func opacity(_ level: OpacityLevel) -> Color {
        opacity(level.rawValue)
    }

    enum OpacityLevel: Double {
        case subtle   = 0.15
        case light    = 0.30
        case medium   = 0.60
        case overlay  = 0.75
        case heavy    = 0.90
    }
}

extension ShapeStyle where Self == Color {
    // Convenience access: Color.netflix.*
    static var netflixBackground: Color { NetflixTheme.Colors.background }
    static var netflixRed: Color        { NetflixTheme.Colors.netflixRed }
}
