import SwiftUI
import CoreText

@main
struct NetflixCloneApp: App {
    @StateObject private var router = AppRouter()

    init() {
        FontLoader.registerFonts()
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(router)
                .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Font Loader
// Registers custom fonts at runtime via CoreText.
// Avoids needing Info.plist UIAppFonts entry when using GENERATE_INFOPLIST_FILE = YES.
private enum FontLoader {
    static func registerFonts() {
        // Logo font
        register(filename: "BebasNeue", extension: "otf")
        // Netflix Sans
        let netflixSans = [
            "NetflixSans-Th", "NetflixSans-ThIt",
            "NetflixSans-Lt", "NetflixSans-LtIt",
            "NetflixSans-Rg", "NetflixSans-It",
            "NetflixSans-Md", "NetflixSans-MdIt",
            "NetflixSans-Bd", "NetflixSans-BdIt",
            "NetflixSans-Blk", "NetflixSans-BlkIt"
        ]
        netflixSans.forEach { register(filename: $0, extension: "ttf") }
    }

    private static func register(filename: String, extension ext: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: ext) else {
            print("⚠️ FontLoader: \(filename).\(ext) not found in bundle")
            return
        }
        var error: Unmanaged<CFError>?
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
        if let error = error?.takeRetainedValue() {
            print("⚠️ FontLoader: failed to register \(filename).\(ext) — \(error)")
        }
    }
}
