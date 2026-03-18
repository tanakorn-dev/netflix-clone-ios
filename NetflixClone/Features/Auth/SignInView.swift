import SwiftUI

struct AuthView: View {
    @EnvironmentObject var router: AppRouter

    var body: some View {
        if router.isSignedIn {
            ProfilePickerView()
                .transition(.netflixFade)
        } else {
            SignInView()
                .transition(.netflixFade)
        }
    }
}

struct SignInView: View {
    @EnvironmentObject var router: AppRouter
    @State private var email = ""
    @State private var isLoading = false
    @State private var contentVisible = false
    @State private var getHelpExpanded = false

    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: Color(hex: "3d0000"), location: 0.0),
                    .init(color: Color(hex: "1a0000"), location: 0.3),
                    .init(color: Color.black, location: 0.5),
                    .init(color: Color.black, location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                navBar

                VStack(alignment: .leading, spacing: 0) {
                    Text("Enter your info to sign in")
                        .font(NetflixTheme.Typography.bold(28))
                        .foregroundColor(NetflixTheme.Colors.textPrimary)
                        .padding(.top, NetflixTheme.Spacing.xl)
                        .padding(.bottom, 40)

                    VStack(spacing: NetflixTheme.Spacing.md) {
                        emailField
                        continueButton
                    }

                    getHelpRow

                    captchaFooter
                }
                .padding(.horizontal, NetflixTheme.Spacing.lg)
                .opacity(contentVisible ? 1 : 0)
                .offset(y: contentVisible ? 0 : 16)

                Spacer()
            }
        }
        .onAppear {
            withAnimation(NetflixAnimation.spring.delay(0.15)) {
                contentVisible = true
            }
        }
    }

    // MARK: - Nav bar
    private var navBar: some View {
        HStack(spacing: NetflixTheme.Spacing.md) {
            Button {} label: {
                Image(systemName: "chevron.left")
                    .font(NetflixTheme.Typography.medium(18))
                    .foregroundColor(NetflixTheme.Colors.textPrimary)
            }

            Image("Netflix_Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 28)

            Spacer()
        }
        .padding(.horizontal, NetflixTheme.Spacing.md)
        .frame(height: 52)
    }

    // MARK: - Email field
    private var emailField: some View {
        FloatingLabelTextField(
            placeholder: "Email address or mobile number",
            text: $email,
            keyboardType: .emailAddress
        )
    }

    // MARK: - Continue button
    private var continueButton: some View {
        Button {
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                isLoading = false
                router.signIn()
            }
        } label: {
            ZStack {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text("Continue")
                        .font(NetflixTheme.Typography.bold(18))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, NetflixTheme.Spacing.md)
            .background(NetflixTheme.Colors.netflixRed)
            .cornerRadius(4)
        }
        .disabled(isLoading)
    }

    // MARK: - Get help
    private var getHelpRow: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    getHelpExpanded.toggle()
                }
            } label: {
                HStack(spacing: 6) {
                    Text("Get help")
                        .font(NetflixTheme.Typography.medium(15))
                        .foregroundColor(NetflixTheme.Colors.textPrimary)
                    Image(systemName: getHelpExpanded ? "chevron.up" : "chevron.down")
                        .font(NetflixTheme.Typography.medium(12))
                        .foregroundColor(NetflixTheme.Colors.textPrimary)
                }
            }
            .buttonStyle(.plain)

            if getHelpExpanded {
                VStack(alignment: .leading, spacing: NetflixTheme.Spacing.sm) {
                    helpLink("Forgot email address or mobile number?", url: "https://www.netflix.com/th-en/loginhelp?fromApp=true")
                    helpLink("Learn more about sign-in", url: "https://help.netflix.com/en/node/311830241325668?fromApp=true")
                }
                .padding(.top, NetflixTheme.Spacing.md)
            }
        }
        .padding(.top, NetflixTheme.Spacing.xl)
    }

    private func helpLink(_ title: String, url: String) -> some View {
        Button {
            if let u = URL(string: url) {
                UIApplication.shared.open(u)
            }
        } label: {
            Text(title)
                .font(NetflixTheme.Typography.regular(14))
                .foregroundColor(NetflixTheme.Colors.textPrimary)
                .underline()
        }
        .buttonStyle(.plain)
    }

    // MARK: - reCAPTCHA footer
    private var captchaFooter: some View {
        (
            Text("This page is protected by Google reCAPTCHA to ensure you're not a bot. ")
                .foregroundColor(NetflixTheme.Colors.textSecondary)
            + Text("Learn more")
                .foregroundColor(NetflixTheme.Colors.textPrimary)
                .underline()
        )
        .font(NetflixTheme.Typography.regular(13))
        .padding(.top, NetflixTheme.Spacing.xl)
    }
}

#Preview {
    SignInView().environmentObject(AppRouter())
}
