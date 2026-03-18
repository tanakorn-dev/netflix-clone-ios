import SwiftUI

struct OTPView: View {
    @EnvironmentObject var router: AppRouter
    @State private var otpDigits: [String] = ["", "", "", ""]
    @State private var activeIndex: Int = 0
    @State private var isLoading = false
    @State private var contentVisible = false
    @FocusState private var focusedIndex: Int?

    private var isComplete: Bool { otpDigits.allSatisfy { $0.count == 1 } }

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
                    // Title
                    Text("Enter the code we sent to your email")
                        .font(NetflixTheme.Typography.bold(28))
                        .foregroundColor(NetflixTheme.Colors.textPrimary)
                        .padding(.top, NetflixTheme.Spacing.xl)
                        .padding(.bottom, 32)

                    // Email row
                    emailRow

                    // OTP boxes
                    otpBoxes
                        .padding(.top, NetflixTheme.Spacing.lg)

                    // Expiry + resend
                    VStack(alignment: .leading, spacing: NetflixTheme.Spacing.xs) {
                        Text("This code will expire in 15 minutes.")
                            .font(NetflixTheme.Typography.regular(14))
                            .foregroundColor(NetflixTheme.Colors.textSecondary)

                        HStack(spacing: 0) {
                            Text("Didn't get a code? ")
                                .font(NetflixTheme.Typography.regular(14))
                                .foregroundColor(NetflixTheme.Colors.textSecondary)
                            Button("Resend code.") {}
                                .font(NetflixTheme.Typography.regular(14))
                                .foregroundColor(NetflixTheme.Colors.textPrimary)
                                .underline()
                        }
                    }
                    .padding(.top, NetflixTheme.Spacing.md)

                    // Get help
                    getHelpRow

                    Spacer()
                }
                .padding(.horizontal, NetflixTheme.Spacing.lg)
                .opacity(contentVisible ? 1 : 0)
                .offset(y: contentVisible ? 0 : 16)
            }

            // Spinner
            if isLoading {
                NetflixSpinner(color: NetflixTheme.Colors.netflixRed, size: 48, lineWidth: 5)
            }
        }
        .onAppear {
            withAnimation(NetflixAnimation.spring.delay(0.15)) {
                contentVisible = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                focusedIndex = 0
            }
        }
    }

    // MARK: - Nav bar
    private var navBar: some View {
        HStack(spacing: NetflixTheme.Spacing.md) {
            Button {
                withAnimation(NetflixAnimation.slowFade) {
                    router.pendingEmail = ""
                }
            } label: {
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

    // MARK: - Email row
    private var emailRow: some View {
        HStack {
            Text(router.pendingEmail)
                .font(NetflixTheme.Typography.regular(15))
                .foregroundColor(NetflixTheme.Colors.textPrimary)
            Spacer()
            Button {
                withAnimation(NetflixAnimation.slowFade) {
                    router.pendingEmail = ""
                }
            } label: {
                Text("Change")
                    .font(NetflixTheme.Typography.regular(15))
                    .foregroundColor(NetflixTheme.Colors.textPrimary)
                    .underline()
            }
        }
        .padding(NetflixTheme.Spacing.md)
        .background(Color.white.opacity(0.35))
        .cornerRadius(4)
    }

    // MARK: - OTP boxes
    private var otpBoxes: some View {
        HStack(spacing: NetflixTheme.Spacing.md) {
            ForEach(0..<4, id: \.self) { index in
                otpBox(index: index)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private func otpBox(index: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.black.opacity(0.5))
            RoundedRectangle(cornerRadius: 4)
                .stroke(
                    focusedIndex == index ? Color.white.opacity(0.8) : NetflixTheme.Colors.textSecondary,
                    lineWidth: focusedIndex == index ? 1.5 : 1
                )

            Text(otpDigits[index])
                .font(NetflixTheme.Typography.bold(24))
                .foregroundColor(NetflixTheme.Colors.textPrimary)

            // Hidden text field
            TextField("", text: Binding(
                get: { otpDigits[index] },
                set: { newVal in
                    let filtered = newVal.filter { $0.isNumber }.prefix(1)
                    otpDigits[index] = String(filtered)
                    if !filtered.isEmpty && index < 3 {
                        focusedIndex = index + 1
                    }
                    if otpDigits.allSatisfy({ $0.count == 1 }) {
                        submitOTP()
                    }
                }
            ))
            .keyboardType(.numberPad)
            .focused($focusedIndex, equals: index)
            .opacity(0.01)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 55, height: 80)
        .onTapGesture { focusedIndex = index }
    }

    // MARK: - Get help
    @State private var getHelpExpanded = false

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

    // MARK: - Submit
    private func submitOTP() {
        isLoading = true
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        Task {
            try? await Task.sleep(for: .seconds(0.8))
            await MainActor.run {
                isLoading = false
                router.verifyOTP()
            }
        }
    }
}

#Preview {
    OTPView().environmentObject(AppRouter())
}
