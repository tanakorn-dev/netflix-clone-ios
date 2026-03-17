import SwiftUI

struct SplashView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            AuthView()
        } else {
            ZStack {
                NetflixTheme.Colors.background.ignoresSafeArea()
                Text("N")
                    .font(.system(size: 80, weight: .black, design: .default))
                    .italic()
                    .foregroundColor(NetflixTheme.Colors.netflixRed)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation { isActive = true }
                }
            }
        }
    }
}

#Preview { SplashView() }
