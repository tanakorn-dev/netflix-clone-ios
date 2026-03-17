import SwiftUI

// MARK: - Netflix Design Tokens
enum NetflixTheme {

    // MARK: Colors
    enum Colors {
        static let background     = Color(hex: "141414")
        static let netflixRed     = Color(hex: "E50914")
        static let textPrimary    = Color.white
        static let textSecondary  = Color(hex: "A0A0A0")
        static let textTertiary   = Color(hex: "5A5A5A")
        static let cardBg         = Color(hex: "1F1F1F")
        static let separator      = Color(hex: "2A2A2A")
        static let matchGreen     = Color(hex: "46D369")
        static let tabActive      = Color.white
        static let tabInactive    = Color(hex: "5A5A5A")
        static let overlayDark    = Color.black.opacity(0.6)
        static let buttonPrimary  = Color.white
        static let buttonSecondary = Color(hex: "333333").opacity(0.9)
    }

    // MARK: Spacing
    enum Spacing {
        static let xs:   CGFloat = 4
        static let sm:   CGFloat = 8
        static let md:   CGFloat = 16
        static let lg:   CGFloat = 24
        static let xl:   CGFloat = 32
        static let xxl:  CGFloat = 48

        // Component-specific
        static let cardWidth:    CGFloat = 104
        static let cardHeight:   CGFloat = 156
        static let cardRadius:   CGFloat = 4
        static let cardGap:      CGFloat = 8
        static let rowPaddingH:  CGFloat = 16
        static let rowGap:       CGFloat = 24
        static let heroHeight:   CGFloat = 480
        static let tabBarHeight: CGFloat = 49
        static let topNavHeight: CGFloat = 44
    }

    // MARK: Typography
    enum Typography {
        static let heroTitle   = Font.system(size: 30, weight: .bold)
        static let rowHeader   = Font.system(size: 16, weight: .medium)
        static let cardTitle   = Font.system(size: 12, weight: .medium)
        static let body        = Font.system(size: 14, weight: .regular)
        static let caption     = Font.system(size: 11, weight: .regular)
        static let buttonText  = Font.system(size: 15, weight: .medium)
        static let navItem     = Font.system(size: 13, weight: .regular)
        static let detailTitle = Font.system(size: 22, weight: .bold)
        static let matchPct    = Font.system(size: 11, weight: .bold)
    }
}

// MARK: - Color from Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
