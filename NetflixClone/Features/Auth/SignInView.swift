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
    @State private var email    = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var isLoading = false
    @State private var fieldsVisible = false

    var body: some View {
        VStack(spacing: NetflixTheme.Spacing.lg) {
            Spacer()

            // Logo
            Text("N")
                .font(.system(size: 60, weight: .black))
                .italic()
                .foregroundColor(NetflixTheme.Colors.netflixRed)

            Text("Sign In")
                .netflixText(.heroTitle)
                .padding(.bottom, NetflixTheme.Spacing.sm)

            // Fields
            VStack(spacing: NetflixTheme.Spacing.sm) {
                netflixTextField("Email or phone number", text: $email)
                passwordField
            }
            .opacity(fieldsVisible ? 1 : 0)
            .offset(y: fieldsVisible ? 0 : 20)

            // Sign in button
            Button {
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    isLoading = false
                    router.signIn()
                }
            } label: {
                ZStack {
                    Text("Sign In")
                        .opacity(isLoading ? 0 : 1)
                    if isLoading {
                        ProgressView()
                            .tint(.black)
                    }
                }
            }
            .netflixButton(.primary)
            .fullWidth()
            .padding(.horizontal, NetflixTheme.Spacing.md)
            .disabled(isLoading)

            Spacer()

            // Footer
            HStack(spacing: 4) {
                Text("New to Netflix?")
                    .netflixText(.body)
                Button("Sign up now.") {}
                    .foregroundColor(NetflixTheme.Colors.textPrimary)
                    .font(NetflixTheme.Typography.body)
            }
            .padding(.bottom, NetflixTheme.Spacing.xl)
        }
        .netflixScreen()
        .onAppear {
            withAnimation(NetflixAnimation.spring.delay(0.2)) {
                fieldsVisible = true
            }
        }
    }

    private var passwordField: some View {
        HStack {
            Group {
                if showPassword {
                    TextField("", text: $password,
                              prompt: Text("Password").foregroundColor(NetflixTheme.Colors.textTertiary))
                } else {
                    SecureField("", text: $password,
                                prompt: Text("Password").foregroundColor(NetflixTheme.Colors.textTertiary))
                }
            }
            .foregroundColor(NetflixTheme.Colors.textPrimary)
            .font(NetflixTheme.Typography.body)

            Button {
                showPassword.toggle()
            } label: {
                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .foregroundColor(NetflixTheme.Colors.textSecondary)
            }
        }
        .padding(NetflixTheme.Spacing.md)
        .background(NetflixTheme.Colors.cardBg)
        .cornerRadius(4)
        .padding(.horizontal, NetflixTheme.Spacing.md)
    }

    private func netflixTextField(_ placeholder: String, text: Binding<String>) -> some View {
        TextField("", text: text,
                  prompt: Text(placeholder).foregroundColor(NetflixTheme.Colors.textTertiary))
            .foregroundColor(NetflixTheme.Colors.textPrimary)
            .font(NetflixTheme.Typography.body)
            .padding(NetflixTheme.Spacing.md)
            .background(NetflixTheme.Colors.cardBg)
            .cornerRadius(4)
            .padding(.horizontal, NetflixTheme.Spacing.md)
    }
}

#Preview {
    SignInView().environmentObject(AppRouter())
}

