import SwiftUI

// MARK: - App Router
// Single source of truth for navigation state.
// Injected as @EnvironmentObject so any view can trigger navigation.
//
// Usage in any view:
//   @EnvironmentObject var router: AppRouter
//   router.showDetail(movie)
//   router.playMovie(movie)

@MainActor
final class AppRouter: ObservableObject {

    // MARK: Auth flow
    @Published var isSignedIn: Bool = UserDefaults.standard.bool(forKey: "isSignedIn") {
        didSet { UserDefaults.standard.set(isSignedIn, forKey: "isSignedIn") }
    }
    @Published var pendingEmail: String = ""
    @Published var selectedProfile: Profile? = nil

    // MARK: Detail sheet
    @Published var detailMovie: Movie? = nil
    var showDetail: Bool {
        get { detailMovie != nil }
        set { if !newValue { detailMovie = nil } }
    }

    // MARK: Player
    @Published var playerMovie: Movie? = nil
    var showPlayer: Bool {
        get { playerMovie != nil }
        set { if !newValue { playerMovie = nil } }
    }

    // MARK: Tab selection
    @Published var selectedTab: Int = 0

    // MARK: Actions
    func requestOTP(email: String) {
        withAnimation(NetflixAnimation.slowFade) { pendingEmail = email }
    }

    func verifyOTP() {
        withAnimation(NetflixAnimation.slowFade) {
            pendingEmail = ""
            isSignedIn = true
        }
    }

    func signIn() {
        withAnimation(NetflixAnimation.slowFade) { isSignedIn = true }
    }

    func selectProfile(_ profile: Profile) {
        withAnimation(NetflixAnimation.spring) { selectedProfile = profile }
    }

    func showDetail(_ movie: Movie) {
        withAnimation(NetflixAnimation.sheetReveal) { detailMovie = movie }
    }

    func dismissDetail() {
        withAnimation(NetflixAnimation.smooth) { detailMovie = nil }
    }

    func playMovie(_ movie: Movie) {
        withAnimation(NetflixAnimation.slowFade) { playerMovie = movie }
    }

    func dismissPlayer() {
        withAnimation(NetflixAnimation.smooth) { playerMovie = nil }
    }

    func switchTab(_ tab: Int) {
        withAnimation(NetflixAnimation.tabBounce) { selectedTab = tab }
    }
}
