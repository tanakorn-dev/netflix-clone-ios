import SwiftUI

// MARK: - Top Navigation Bar
// Transparent nav that fades to black as user scrolls down.
// Usage:
//   TopNavBar(scrollOffset: $offset, selectedCategory: $category)

struct TopNavBar: View {
    enum Category: String, CaseIterable {
        case home      = "Home"
        case tvShows   = "TV Shows"
        case movies    = "Movies"
        case myList    = "My List"
    }

    @Binding var scrollOffset: CGFloat
    @Binding var selectedCategory: Category

    // Derived opacity — fade in background as user scrolls
    private var backgroundOpacity: Double {
        min(Double(scrollOffset) / 100.0, 1.0)
    }

    var body: some View {
        VStack(spacing: 0) {
            mainBar
            categoryBar
        }
        .background(
            NetflixTheme.Colors.background
                .opacity(backgroundOpacity)
                .ignoresSafeArea()
        )
    }

    // MARK: Main bar — Logo + profile icon
    private var mainBar: some View {
        HStack {
            // Netflix "N" wordmark
            Text("N")
                .font(.system(size: 36, weight: .black))
                .italic()
                .foregroundColor(NetflixTheme.Colors.netflixRed)

            Spacer()

            HStack(spacing: NetflixTheme.Spacing.md) {
                Button {
                    // TODO: Search action
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(NetflixTheme.Colors.textPrimary)
                        .font(.system(size: 20))
                }

                // Profile avatar (mini)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.blue)
                    .frame(width: 28, height: 28)
            }
        }
        .padding(.horizontal, NetflixTheme.Spacing.md)
        .frame(height: NetflixTheme.Spacing.topNavHeight)
    }

    // MARK: Category pills
    private var categoryBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: NetflixTheme.Spacing.sm) {
                ForEach(Category.allCases, id: \.self) { category in
                    categoryPill(category)
                }
            }
            .padding(.horizontal, NetflixTheme.Spacing.md)
            .padding(.bottom, NetflixTheme.Spacing.sm)
        }
    }

    private func categoryPill(_ category: Category) -> some View {
        let isSelected = selectedCategory == category
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedCategory = category
            }
        } label: {
            Text(category.rawValue)
                .font(NetflixTheme.Typography.navItem)
                .foregroundColor(isSelected
                    ? NetflixTheme.Colors.textPrimary
                    : NetflixTheme.Colors.textSecondary)
                .padding(.horizontal, NetflixTheme.Spacing.md)
                .padding(.vertical, NetflixTheme.Spacing.xs)
                .background(
                    isSelected
                        ? NetflixTheme.Colors.cardBg
                        : Color.clear
                )
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isSelected
                                ? NetflixTheme.Colors.textSecondary
                                : Color.clear,
                            lineWidth: 0.5
                        )
                )
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack(alignment: .top) {
        NetflixTheme.Colors.background.ignoresSafeArea()
        TopNavBar(
            scrollOffset: .constant(0),
            selectedCategory: .constant(.home)
        )
    }
}
