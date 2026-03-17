import SwiftUI

struct AuthView: View {
    @State private var isSignedIn = false

    var body: some View {
        if isSignedIn {
            ProfilePickerView()
        } else {
            SignInView(onSignIn: { isSignedIn = true })
        }
    }
}

struct SignInView: View {
    var onSignIn: () -> Void
    @State private var email    = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            NetflixTheme.Colors.background.ignoresSafeArea()
            VStack(spacing: NetflixTheme.Spacing.lg) {
                Text("N")
                    .font(.system(size: 60, weight: .black))
                    .italic()
                    .foregroundColor(NetflixTheme.Colors.netflixRed)
                    .padding(.bottom, NetflixTheme.Spacing.xl)

                Text("Sign In")
                    .font(NetflixTheme.Typography.heroTitle)
                    .foregroundColor(NetflixTheme.Colors.textPrimary)

                // TODO: Phase 3 — build proper form components
                Button("Sign In (skip for now)") { onSignIn() }
                    .foregroundColor(NetflixTheme.Colors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(NetflixTheme.Colors.netflixRed)
                    .cornerRadius(4)
                    .padding(.horizontal, NetflixTheme.Spacing.md)
            }
        }
    }
}

#Preview { SignInView(onSignIn: {}) }
