import SwiftUI

// MARK: - Shared Auth Background
struct AuthBackground: View {
    var body: some View {
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
    }
}

// MARK: - Shared Auth Nav Bar
struct AuthNavBar: View {
    var onBack: (() -> Void)?

    var body: some View {
        HStack(spacing: NetflixTheme.Spacing.md) {
            Button {
                onBack?()
            } label: {
                Image(systemName: "chevron.left")
                    .font(NetflixTheme.Typography.medium(18))
                    .foregroundColor(NetflixTheme.Colors.textPrimary)
                    .opacity(onBack != nil ? 1 : 0)
            }
            .disabled(onBack == nil)

            Image("Netflix_Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 28)

            Spacer()
        }
        .padding(.horizontal, NetflixTheme.Spacing.md)
        .frame(height: 52)
    }
}

// MARK: - Shared Get Help Row
struct GetHelpRow: View {
    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    expanded.toggle()
                }
            } label: {
                HStack(spacing: 6) {
                    Text("Get help")
                        .font(NetflixTheme.Typography.medium(15))
                        .foregroundColor(NetflixTheme.Colors.textPrimary)
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(NetflixTheme.Typography.medium(12))
                        .foregroundColor(NetflixTheme.Colors.textPrimary)
                }
            }
            .buttonStyle(.plain)

            if expanded {
                VStack(alignment: .leading, spacing: NetflixTheme.Spacing.sm) {
                    AuthHelpLink("Forgot email address or mobile number?",
                                 url: "https://www.netflix.com/th-en/loginhelp?fromApp=true")
                    AuthHelpLink("Learn more about sign-in",
                                 url: "https://help.netflix.com/en/node/311830241325668?fromApp=true")
                }
                .padding(.top, NetflixTheme.Spacing.md)
            }
        }
        .padding(.top, NetflixTheme.Spacing.xl)
    }
}

// MARK: - Auth Help Link
struct AuthHelpLink: View {
    let title: String
    let url: String

    init(_ title: String, url: String) {
        self.title = title
        self.url = url
    }

    var body: some View {
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
}

// MARK: - Dismiss keyboard helper
extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Auth loading helper
func authLoad(action: @escaping @MainActor () -> Void) {
    UIApplication.shared.dismissKeyboard()
    Task {
        try? await Task.sleep(for: .seconds(0.8))
        await MainActor.run { action() }
    }
}
