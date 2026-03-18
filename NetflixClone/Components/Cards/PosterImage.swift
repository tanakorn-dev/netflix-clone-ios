import SwiftUI

// MARK: - Poster Image
// Async image with shimmer loading state and fallback color block.
// Usage:
//   PosterImage(url: movie.thumbnailURL)
//   PosterImage(url: movie.backdropURL, contentMode: .fill)

struct PosterImage: View {
    let url: String
    var contentMode: ContentMode = .fill
    var width: CGFloat  = NetflixTheme.Spacing.cardWidth
    var height: CGFloat = NetflixTheme.Spacing.cardHeight
    var cornerRadius: CGFloat = NetflixTheme.Spacing.cardRadius

    // Fallback color derived from url hash so each card gets a consistent tint
    private var fallbackColor: Color {
        let colors: [Color] = [
            Color(hex: "1a1a2e"), Color(hex: "16213e"),
            Color(hex: "1b262c"), Color(hex: "0f3460"),
            Color(hex: "2c003e"), Color(hex: "1b1b2f")
        ]
        let index = abs(url.hashValue) % colors.count
        return colors[index]
    }

    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                fallbackColor
                    .frame(width: width, height: height)
                    .shimmer()

            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .frame(width: width, height: height)

            case .failure:
                fallbackColor
                    .frame(width: width, height: height)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(NetflixTheme.Colors.textTertiary)
                            .font(.system(size: 24))
                    )

            @unknown default:
                fallbackColor.frame(width: width, height: height)
            }
        }
        .frame(width: width, height: height)
        .clipped()
        .cornerRadius(cornerRadius)
    }
}

// MARK: - Preview
#Preview {
    HStack(spacing: 8) {
        // Empty / shimmer state
        PosterImage(url: "")
        // Simulated failure
        PosterImage(url: "not-a-url")
        // Wide format
        PosterImage(url: "", width: 160, height: 90)
    }
    .padding()
    .netflixScreen()
}
