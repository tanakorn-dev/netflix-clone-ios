import SwiftUI

// MARK: - Image Cache
// Singleton NSCache — survives the app session, cleared on memory pressure.
final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()

    private init() {
        cache.countLimit = 100       // max 100 images
        cache.totalCostLimit = 1024 * 1024 * 150  // 150 MB
    }

    func get(_ url: String) -> UIImage? {
        cache.object(forKey: url as NSString)
    }

    func set(_ image: UIImage, for url: String) {
        let cost = Int(image.size.width * image.size.height * 4)
        cache.setObject(image, forKey: url as NSString, cost: cost)
    }
}

// MARK: - CachedAsyncImage
// Drop-in replacement for AsyncImage with automatic NSCache caching.
//
// Usage (same API as PosterImage):
//   CachedAsyncImage(url: movie.backdropURL)
//   CachedAsyncImage(url: movie.backdropURL, contentMode: .fill)
//
struct CachedAsyncImage: View {
    let url: String
    var contentMode: ContentMode = .fill
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var cornerRadius: CGFloat = 0

    @State private var image: UIImage? = nil
    @State private var isLoading = false

    private var fallbackColor: Color {
        let colors: [Color] = [
            Color(hex: "0d1b2a"), Color(hex: "1b2838"),
            Color(hex: "2c0b0b"), Color(hex: "0b2c1a"),
            Color(hex: "1a0b2c"), Color(hex: "2c1f0b")
        ]
        return colors[abs(url.hashValue) % colors.count]
    }

    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .frame(width: width, height: height)
                    .clipped()
                    .cornerRadius(cornerRadius)
            } else {
                fallbackColor
                    .frame(width: width, height: height)
                    .cornerRadius(cornerRadius)
                    .shimmer()
            }
        }
        .onAppear { load() }
        .onChange(of: url) { _, _ in load() }
    }

    private func load() {
        guard !url.isEmpty, let parsedURL = URL(string: url) else { return }

        // Cache hit — instant display
        if let cached = ImageCache.shared.get(url) {
            image = cached
            return
        }

        // Cache miss — fetch and store
        guard !isLoading else { return }
        isLoading = true

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: parsedURL)
                if let downloaded = UIImage(data: data) {
                    ImageCache.shared.set(downloaded, for: url)
                    await MainActor.run { image = downloaded }
                }
            } catch {
                // silently falls back to placeholder color
            }
            await MainActor.run { isLoading = false }
        }
    }
}
