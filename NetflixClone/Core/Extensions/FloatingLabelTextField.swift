import SwiftUI

// MARK: - Floating Label TextField
// Drop-in replacement for TextField with animated floating placeholder.
//
// Usage:
//   FloatingLabelTextField("Email address", text: $email)
//   FloatingLabelTextField("Password", text: $password, isSecure: true)
//   FloatingLabelTextField("Email", text: $email, keyboardType: .emailAddress)

struct FloatingLabelTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default

    @FocusState private var isFocused: Bool
    @State private var showPassword: Bool = false

    private var isFloating: Bool { isFocused || !text.isEmpty }

    var body: some View {
        ZStack(alignment: .leading) {
            // Background + border
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.black.opacity(0.5))
            RoundedRectangle(cornerRadius: 4)
                .stroke(
                    isFocused ? Color.white.opacity(0.8) : NetflixTheme.Colors.textSecondary,
                    lineWidth: isFocused ? 1.5 : 1
                )

            // Floating placeholder
            Text(placeholder)
                .font(
                    isFloating
                        ? NetflixTheme.Typography.regular(11)
                        : NetflixTheme.Typography.regular(16)
                )
                .foregroundColor(
                    isFocused
                        ? .white.opacity(0.6)
                        : NetflixTheme.Colors.textSecondary
                )
                .offset(y: isFloating ? -12 : 0)
                .padding(.horizontal, 14)
                .animation(.easeInOut(duration: 0.2), value: isFloating)

            // Input field
            HStack {
                Group {
                    if isSecure && !showPassword {
                        SecureField("", text: $text)
                    } else {
                        TextField("", text: $text)
                            .keyboardType(keyboardType)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                }
                .font(NetflixTheme.Typography.regular(16))
                .foregroundColor(NetflixTheme.Colors.textPrimary)
                .focused($isFocused)
                .padding(.horizontal, 14)
                .padding(.top, isFloating ? 16 : 0)

                // Eye toggle for secure field
                if isSecure {
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .font(.system(size: 14))
                            .foregroundColor(NetflixTheme.Colors.textSecondary)
                    }
                    .padding(.trailing, 14)
                }
            }
        }
        .frame(height: 56)
        .contentShape(Rectangle())
        .onTapGesture { isFocused = true }
    }
}

#Preview {
    VStack(spacing: 16) {
        FloatingLabelTextField(placeholder: "Email address or mobile number", text: .constant(""))
        FloatingLabelTextField(placeholder: "Email address or mobile number", text: .constant("test@example.com"))
        FloatingLabelTextField(placeholder: "Password", text: .constant(""), isSecure: true)
    }
    .padding()
    .background(Color.black)
}
