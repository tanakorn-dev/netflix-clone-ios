import SwiftUI

// MARK: - Design System Preview Canvas
// Open this file in Xcode and hit the Preview button
// to see all tokens and modifiers at a glance.

struct DesignSystemPreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                colorSection
                typographySection
                spacingSection
                buttonSection
                cardSection
                modifierSection
            }
            .padding(NetflixTheme.Spacing.md)
        }
        .netflixScreen()
    }

    // MARK: Colors
    private var colorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Colors")
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                colorSwatch(NetflixTheme.Colors.background,    "Background")
                colorSwatch(NetflixTheme.Colors.netflixRed,   "Netflix red")
                colorSwatch(NetflixTheme.Colors.textPrimary,  "Text primary")
                colorSwatch(NetflixTheme.Colors.textSecondary,"Text secondary")
                colorSwatch(NetflixTheme.Colors.textTertiary, "Text tertiary")
                colorSwatch(NetflixTheme.Colors.cardBg,       "Card bg")
                colorSwatch(NetflixTheme.Colors.separator,    "Separator")
                colorSwatch(NetflixTheme.Colors.matchGreen,   "Match green")
            }
        }
    }

    private func colorSwatch(_ color: Color, _ label: String) -> some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(height: 48)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(NetflixTheme.Colors.separator, lineWidth: 0.5)
                )
            Text(label)
                .netflixText(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: Typography
    private var typographySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Typography")
            Group {
                Text("Hero title — 30pt bold")
                    .netflixText(.heroTitle)
                Text("Detail title — 22pt bold")
                    .netflixText(.detailTitle)
                Text("Row header — 16pt medium")
                    .netflixText(.rowHeader)
                Text("Button text — 15pt medium")
                    .netflixText(.buttonText)
                Text("Body — 14pt regular")
                    .netflixText(.body)
                Text("Nav item — 13pt regular")
                    .netflixText(.navItem)
                Text("Card title — 12pt medium")
                    .netflixText(.cardTitle)
                Text("Caption — 11pt regular")
                    .netflixText(.caption)
                Text("98% Match")
                    .netflixText(.matchPercentage)
            }
        }
    }

    // MARK: Spacing
    private var spacingSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Spacing scale")
            HStack(alignment: .bottom, spacing: 12) {
                spacingBar(NetflixTheme.Spacing.xs,  "xs 4")
                spacingBar(NetflixTheme.Spacing.sm,  "sm 8")
                spacingBar(NetflixTheme.Spacing.md,  "md 16")
                spacingBar(NetflixTheme.Spacing.lg,  "lg 24")
                spacingBar(NetflixTheme.Spacing.xl,  "xl 32")
                spacingBar(NetflixTheme.Spacing.xxl, "xxl 48")
            }
        }
    }

    private func spacingBar(_ value: CGFloat, _ label: String) -> some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 2)
                .fill(NetflixTheme.Colors.netflixRed)
                .frame(width: 28, height: value)
            Text(label)
                .netflixText(.caption)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: Buttons
    private var buttonSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Button styles")
            HStack(spacing: 12) {
                Text("▶  Play")
                    .netflixButton(.primary)
                Text("ⓘ  More Info")
                    .netflixButton(.secondary)
                Image(systemName: "plus")
                    .netflixButton(.icon)
            }
        }
    }

    // MARK: Cards
    private var cardSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Card sizes")
            HStack(spacing: 8) {
                cardPlaceholder(w: NetflixTheme.Spacing.cardWidth,
                                h: NetflixTheme.Spacing.cardHeight,
                                label: "Default\n104×156")
                cardPlaceholder(w: 130, h: 195, label: "Large\n130×195")
                cardPlaceholder(w: 240, h: 135, label: "Wide\n240×135")
            }
        }
    }

    private func cardPlaceholder(w: CGFloat, h: CGFloat, label: String) -> some View {
        Text(label)
            .netflixText(.caption)
            .multilineTextAlignment(.center)
            .netflixCard(width: w, height: h)
    }

    // MARK: Modifiers
    private var modifierSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Shimmer loading state")
            HStack(spacing: 8) {
                ForEach(0..<3) { _ in
                    RoundedRectangle(cornerRadius: NetflixTheme.Spacing.cardRadius)
                        .fill(NetflixTheme.Colors.cardBg)
                        .frame(width: NetflixTheme.Spacing.cardWidth,
                               height: NetflixTheme.Spacing.cardHeight)
                        .shimmer()
                }
            }
            .padding(.horizontal, NetflixTheme.Spacing.rowPaddingH)
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .netflixText(.rowHeader)
            Rectangle()
                .fill(NetflixTheme.Colors.separator)
                .frame(height: 0.5)
        }
    }
}

#Preview {
    DesignSystemPreview()
}
