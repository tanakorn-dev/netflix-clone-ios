import SwiftUI

// MARK: - Floating Label TextField
// Drop-in replacement for TextField with animated floating placeholder.
//
// Usage:
//   FloatingLabelTextField(placeholder: "Email", text: $email)
//   FloatingLabelTextField(placeholder: "Email", text: $email, hasError: $emailError)
//   FloatingLabelTextField(placeholder: "Password", text: $password, isSecure: true)

struct FloatingLabelTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var hasError: Binding<Bool>? = nil

    @FocusState private var isFocused: Bool
    @State private var showPassword: Bool = false

    private var isFloating: Bool { isFocused || !text.isEmpty }
    private var isError: Bool { hasError?.wrappedValue ?? false }

    private var borderColor: Color {
        if isError { return NetflixTheme.Colors.netflixRed }
        if isFocused { return Color.white.opacity(0.8) }
        return NetflixTheme.Colors.textSecondary
    }

    private var borderWidth: CGFloat {
        isError || isFocused ? 1.5 : 1
    }

    var body: some View {
        ZStack(alignment: .leading) {
            // Background + border
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.black.opacity(0.5))
            RoundedRectangle(cornerRadius: 4)
                .stroke(borderColor, lineWidth: borderWidth)
                .animation(.easeInOut(duration: 0.15), value: isError)

            // Floating placeholder
            Text(placeholder)
                .font(
                    isFloating
                        ? NetflixTheme.Typography.regular(11)
                        : NetflixTheme.Typography.regular(16)
                )
                .foregroundColor(NetflixTheme.Colors.textSecondary)
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
                .onChange(of: text) { _, _ in
                    if isError { hasError?.wrappedValue = false }
                }

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
        FloatingLabelTextField(placeholder: "Email (error)", text: .constant(""), hasError: .constant(true))
        FloatingLabelTextField(placeholder: "Password", text: .constant(""), isSecure: true)
    }
    .padding()
    .background(Color.black)
}
