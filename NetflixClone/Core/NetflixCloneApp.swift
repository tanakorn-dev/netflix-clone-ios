import SwiftUI

@main
struct NetflixCloneApp: App {
    @StateObject private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(router)
                .preferredColorScheme(.dark)
        }
    }
}
