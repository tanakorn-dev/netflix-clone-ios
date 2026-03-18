import SwiftUI

// MARK: - Netflix Border Spinner
// A circular border spinner — thin ring with a colored arc that rotates.
//
// Usage:
//   NetflixSpinner()
//   NetflixSpinner(color: NetflixTheme.Colors.netflixRed, size: 48, lineWidth: 3)

struct NetflixSpinner: View {
    var color: Color = NetflixTheme.Colors.netflixRed
    var size: CGFloat = 44
    var lineWidth: CGFloat = 3

    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            // Track ring
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
                .frame(width: size, height: size)

            // Spinning arc
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(rotation))
                .onAppear {
                    withAnimation(.linear(duration: 0.9).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        NetflixSpinner()
    }
}
