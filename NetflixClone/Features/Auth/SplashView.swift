import SwiftUI

struct SplashView: View {
    @EnvironmentObject var router: AppRouter
    @State private var scale: CGFloat = 0.6
    @State private var opacity: Double = 0
    @State private var isActive = false

    var body: some View {
        ZStack {
            if isActive {
                AuthView()
                    .transition(.netflixFade)
            } else {
                splashContent
            }
        }
        .netflixScreen()
    }

    private var splashContent: some View {
        Text("N")
            .font(.system(size: 90, weight: .black))
            .italic()
            .foregroundColor(NetflixTheme.Colors.netflixRed)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                // Phase 1: logo zooms in
                withAnimation(NetflixAnimation.spring) {
                    scale = 1.0
                    opacity = 1.0
                }
                // Phase 2: hold then fade out to main flow
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    withAnimation(NetflixAnimation.slowFade) {
                        isActive = true
                    }
                }
            }
    }
}

#Preview {
    SplashView().environmentObject(AppRouter())
}

