import SwiftUI

struct AuthView: View {
    @EnvironmentObject var router: AppRouter

    var body: some View {
        if router.isSignedIn {
            ProfilePickerView()
                .transition(.netflixFade)
        } else if !router.pendingEmail.isEmpty {
            OTPView()
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
    @State private var emailError = false
    @State private var isLoading = false
    @State private var contentVisible = false

    var body: some View {
        ZStack {
            AuthBackground()

            VStack(alignment: .leading, spacing: 0) {
                AuthNavBar()

                VStack(alignment: .leading, spacing: 0) {
                    Text("Enter your info to sign in")
                        .font(NetflixTheme.Typography.bold(28))
                        .foregroundColor(NetflixTheme.Colors.textPrimary)
                        .padding(.top, NetflixTheme.Spacing.xl)
                        .padding(.bottom, 40)

                    VStack(spacing: NetflixTheme.Spacing.md) {
                        VStack(alignment: .leading, spacing: NetflixTheme.Spacing.xs) {
                            FloatingLabelTextField(
                                placeholder: "Email address or mobile number",
                                text: $email,
                                keyboardType: .emailAddress,
                                hasError: $emailError
                            )
                            if emailError {
                                HStack(spacing: 6) {
                                    Image(systemName: "xmark.circle")
                                        .font(.system(size: 13))
                                        .foregroundColor(NetflixTheme.Colors.netflixRed)
                                    Text("Please enter a valid email address or phone number")
                                        .font(NetflixTheme.Typography.regular(13))
                                        .foregroundColor(NetflixTheme.Colors.netflixRed)
                                }
                            }
                        }

                        Button {
                            guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
                                emailError = true
                                return
                            }
                            isLoading = true
                            authLoad {
                                isLoading = false
                                router.requestOTP(email: email)
                            }
                        } label: {
                            Text("Continue")
                                .font(NetflixTheme.Typography.bold(18))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, NetflixTheme.Spacing.md)
                                .background(NetflixTheme.Colors.netflixRed)
                                .cornerRadius(4)
                        }
                        .disabled(isLoading)
                    }

                    GetHelpRow()

                    captchaFooter
                }
                .padding(.horizontal, NetflixTheme.Spacing.lg)
                .opacity(contentVisible ? 1 : 0)
                .offset(y: contentVisible ? 0 : 16)

                Spacer()
            }

            if isLoading {
                NetflixSpinner(color: NetflixTheme.Colors.netflixRed, size: 48, lineWidth: 5)
            }
        }
        .onAppear {
            withAnimation(NetflixAnimation.spring.delay(0.15)) {
                contentVisible = true
            }
        }
    }

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
