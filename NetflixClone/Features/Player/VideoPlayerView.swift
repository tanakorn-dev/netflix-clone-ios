import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let movie: Movie
    @EnvironmentObject var router: AppRouter
    @Environment(\.dismiss) private var dismiss
    @State private var player: AVPlayer? = nil
    @State private var isPlaying = true
    @State private var showControls = true
    @State private var progress: Double = 0.3
    @State private var controlsTimer: Timer? = nil

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let player {
                VideoPlayer(player: player).ignoresSafeArea()
            } else {
                placeholderBackground
            }

            if showControls {
                controlsOverlay
                    .transition(.netflixFade)
            }
        }
        .statusBarHidden(true)
        .onTapGesture { toggleControls() }
        .onAppear { setupPlayer() }
        .onDisappear { player?.pause() }
    }

    private var placeholderBackground: some View {
        ZStack {
            NetflixTheme.Colors.background
            VStack(spacing: 8) {
                Image(systemName: "play.rectangle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(NetflixTheme.Colors.textTertiary)
                Text(movie.title).netflixText(.rowHeader)
            }
        }
    }

    private var controlsOverlay: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            VStack {
                // Top bar
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text(movie.title)
                        .foregroundColor(.white)
                        .font(NetflixTheme.Typography.body)
                    Spacer()
                    Button {} label: {
                        Image(systemName: "airplayvideo")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, NetflixTheme.Spacing.md)
                .padding(.top, NetflixTheme.Spacing.xl)

                Spacer()

                // Playback controls
                HStack(spacing: 48) {
                    Button {} label: {
                        Image(systemName: "gobackward.10")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    Button {
                        isPlaying.toggle()
                        isPlaying ? player?.play() : player?.pause()
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                    Button {} label: {
                        Image(systemName: "goforward.10")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                }

                Spacer()

                // Scrubber
                VStack(spacing: NetflixTheme.Spacing.xs) {
                    Slider(value: $progress, in: 0...1)
                        .tint(NetflixTheme.Colors.netflixRed)
                        .padding(.horizontal, NetflixTheme.Spacing.md)
                    HStack {
                        Text(formattedTime(progress * 6840))
                            .foregroundColor(.white)
                            .font(NetflixTheme.Typography.caption)
                        Spacer()
                        Text("-\(formattedTime((1 - progress) * 6840))")
                            .foregroundColor(NetflixTheme.Colors.textSecondary)
                            .font(NetflixTheme.Typography.caption)
                    }
                    .padding(.horizontal, NetflixTheme.Spacing.md)
                }
                .padding(.bottom, NetflixTheme.Spacing.xl)
            }
        }
    }

    private func setupPlayer() { resetControlsTimer() }

    private func toggleControls() {
        withAnimation(NetflixAnimation.smooth) { showControls.toggle() }
        if showControls { resetControlsTimer() }
    }

    private func resetControlsTimer() {
        controlsTimer?.invalidate()
        controlsTimer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false) { _ in
            withAnimation(NetflixAnimation.smooth) { showControls = false }
        }
    }

    private func formattedTime(_ seconds: Double) -> String {
        let s = Int(seconds)
        return String(format: "%d:%02d", s / 60, s % 60)
    }
}

#Preview {
    VideoPlayerView(movie: MockData.heroMovie)
        .environmentObject(AppRouter())
}

