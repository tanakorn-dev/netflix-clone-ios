import SwiftUI

// MARK: - Image Cache
// Two-level cache:
//   Level 1 — NSCache (memory): instant access, cleared on memory pressure or kill
//   Level 2 — FileManager (disk): persists across app launches, 7-day expiry
//
// Load order: memory hit → disk hit → network fetch
// Write order: network → write disk → write memory

final class ImageCache {
    static let shared = ImageCache()

    // MARK: Memory cache
    private let memoryCache = NSCache<NSString, UIImage>()

    // MARK: Disk cache config
    private let diskCacheDir: URL
    private let maxDiskAgeDays: Double = 7
    private let maxDiskSizeMB: Int = 200

    private init() {
        memoryCache.countLimit = 100
        memoryCache.totalCostLimit = 1024 * 1024 * 150  // 150 MB

        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        diskCacheDir = caches.appendingPathComponent("ImageCache", isDirectory: true)
        try? FileManager.default.createDirectory(at: diskCacheDir, withIntermediateDirectories: true)

        // Clean expired files on init (background)
        Task.detached(priority: .background) { [weak self] in
            self?.evictExpiredDiskCache()
        }
    }

    // MARK: - Get
    func get(_ url: String) -> UIImage? {
        let key = url as NSString

        // Level 1: memory
        if let cached = memoryCache.object(forKey: key) {
            return cached
        }

        // Level 2: disk
        let fileURL = diskPath(for: url)
        guard FileManager.default.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }

        // Promote to memory cache
        let cost = Int(image.size.width * image.size.height * 4)
        memoryCache.setObject(image, forKey: key, cost: cost)
        // Touch modification date to reset expiry
        try? FileManager.default.setAttributes(
            [.modificationDate: Date()],
            ofItemAtPath: fileURL.path
        )
        return image
    }

    // MARK: - Set
    func set(_ image: UIImage, for url: String) {
        let key = url as NSString

        // Write memory
        let cost = Int(image.size.width * image.size.height * 4)
        memoryCache.setObject(image, forKey: key, cost: cost)

        // Write disk (background)
        let fileURL = diskPath(for: url)
        Task.detached(priority: .background) {
            if let data = image.jpegData(compressionQuality: 0.85) {
                try? data.write(to: fileURL, options: .atomic)
            }
        }
    }

    // MARK: - Disk path
    private func diskPath(for url: String) -> URL {
        let filename: String
        if let data = url.data(using: .utf8) {
            filename = String(
                Data(data).base64EncodedString()
                    .replacingOccurrences(of: "/", with: "_")
                    .replacingOccurrences(of: "+", with: "-")
                    .prefix(64)
            )
        } else {
            filename = String(abs(url.hashValue))
        }
        return diskCacheDir.appendingPathComponent(filename + ".jpg")
    }

    // MARK: - Evict expired / oversized disk cache
    private func evictExpiredDiskCache() {
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: diskCacheDir,
            includingPropertiesForKeys: [.contentModificationDateKey, .fileSizeKey]
        ) else { return }

        let expiryCutoff = Date().addingTimeInterval(-maxDiskAgeDays * 86400)
        var totalBytes = 0

        let sorted = files.compactMap { url -> (URL, Date, Int)? in
            let attrs = try? url.resourceValues(forKeys: [.contentModificationDateKey, .fileSizeKey])
            return (url, attrs?.contentModificationDate ?? .distantPast, attrs?.fileSize ?? 0)
        }.sorted { $0.1 > $1.1 }  // newest first

        for (fileURL, modDate, size) in sorted {
            if modDate < expiryCutoff {
                try? FileManager.default.removeItem(at: fileURL)
                continue
            }
            totalBytes += size
            if totalBytes > maxDiskSizeMB * 1024 * 1024 {
                try? FileManager.default.removeItem(at: fileURL)
            }
        }
    }

    // MARK: - Clear all (debug / settings)
    func clearAll() {
        memoryCache.removeAllObjects()
        try? FileManager.default.removeItem(at: diskCacheDir)
        try? FileManager.default.createDirectory(at: diskCacheDir, withIntermediateDirectories: true)
    }
}

// MARK: - CachedAsyncImage
// Drop-in replacement for AsyncImage with automatic 2-level caching.
//
// Usage:
//   CachedAsyncImage(url: movie.backdropURL)
//   CachedAsyncImage(url: movie.backdropURL, contentMode: .fill)
//   CachedAsyncImage(url: movie.backdropURL, width: 300, height: 200, cornerRadius: 8)

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

        // Level 1 (memory) + Level 2 (disk)
        if let cached = ImageCache.shared.get(url) {
            image = cached
            return
        }

        // Level 3: network
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
