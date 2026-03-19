import SwiftUI

struct OTPView: View {
    @EnvironmentObject var router: AppRouter
    @State private var otpDigits: [String] = ["", "", "", ""]
    @State private var isLoading = false
    @State private var contentVisible = false
    @FocusState private var focusedIndex: Int?

    var body: some View {
        ZStack {
            AuthBackground()

            VStack(alignment: .leading, spacing: 0) {
                AuthNavBar {
                    withAnimation(NetflixAnimation.slowFade) {
                        router.pendingEmail = ""
                    }
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("Enter the code we sent to your email")
                        .font(NetflixTheme.Typography.bold(28))
                        .foregroundColor(NetflixTheme.Colors.textPrimary)
                        .padding(.top, NetflixTheme.Spacing.xl)
                        .padding(.bottom, 32)

                    emailRow
                    otpBoxes.padding(.top, NetflixTheme.Spacing.lg)
                    codeFooter.padding(.top, NetflixTheme.Spacing.md)
                    GetHelpRow()
                    Spacer()
                }
                .padding(.horizontal, NetflixTheme.Spacing.lg)
                .opacity(contentVisible ? 1 : 0)
                .offset(y: contentVisible ? 0 : 16)
            }

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

    // MARK: - Email row
    private var emailRow: some View {
        HStack {
            Text(router.pendingEmail)
                .font(NetflixTheme.Typography.regular(15))
                .foregroundColor(NetflixTheme.Colors.textPrimary)
            Spacer()
            Button {
                withAnimation(NetflixAnimation.slowFade) { router.pendingEmail = "" }
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
            TextField("", text: Binding(
                get: { otpDigits[index] },
                set: { newVal in
                    let filtered = newVal.filter { $0.isNumber }.prefix(1)
                    otpDigits[index] = String(filtered)
                    if !filtered.isEmpty && index < 3 { focusedIndex = index + 1 }
                    if otpDigits.allSatisfy({ $0.count == 1 }) { submit() }
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

    // MARK: - Code footer
    private var codeFooter: some View {
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
    }

    // MARK: - Submit
    private func submit() {
        isLoading = true
        authLoad {
            isLoading = false
            router.verifyOTP()
        }
    }
}

#Preview {
    OTPView().environmentObject(AppRouter())
}
