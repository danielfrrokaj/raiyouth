import SwiftUI
import AVFoundation

// MARK: - Looping sky video player
private struct SkyLoopPlayer: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true

        guard let path = Bundle.main.path(forResource: "skymoving", ofType: "mp4") else {
            return view
        }

        let url = URL(fileURLWithPath: path)
        let item = AVPlayerItem(url: url)
        let player = AVQueuePlayer(playerItem: item)
        let looper = AVPlayerLooper(player: player, templateItem: item)
        player.isMuted = true
        player.play()

        context.coordinator.player = player
        context.coordinator.looper = looper

        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        layer.backgroundColor = UIColor.clear.cgColor
        view.layer.addSublayer(layer)
        context.coordinator.playerLayer = layer

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            context.coordinator.playerLayer?.frame = uiView.bounds
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    class Coordinator {
        var player: AVQueuePlayer?
        var looper: AVPlayerLooper?
        var playerLayer: AVPlayerLayer?
        deinit { player?.pause() }
    }
}

struct MoneyIslandProgressView: View {
    let currentStep: Int // Current onboarding step (1 to 20)
    
    // The visual image is based on what's ALREADY completed
    var imageName: String {
        switch currentStep {
        case 5:       return "island_base"
        case 6, 7:    return "island_guide"
        case 8, 9:    return "island_tower"
        case 10...16: return "island_house"
        case 17, 18:  return "island_gate"
        case 19:      return "island_pin"
        default:      return ""
        }
    }

    // The step number and step label represent what the user is CURRENTLY doing
    var currentDoingStep: Int {
        switch currentStep {
        case 5:       return 1
        case 6, 7:    return 2
        case 8, 9:    return 3
        case 10...16: return 4
        case 17:      return 5
        case 18:      return 6
        case 19:      return 7
        default:      return 0
        }
    }
    
    var islandStepName: String {
        switch currentDoingStep {
        case 1: return "Meet your guide"
        case 2: return "Signal tower"
        case 3: return "Profile house"
        case 4: return "Trust gate"
        case 5: return "Home base"
        case 6: return "Vault lock"
        case 7: return "Island complete"
        default: return "Welcome to RaiYouth"
        }
    }
    
    @State private var floatOffset: CGFloat = 0.0
    @State private var scaleEffect: CGFloat = 1.0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        VStack(spacing: 8) {
            if currentDoingStep > 0 {
                // The Island Image (Floating + Zoom effect)
                ZStack {
                    // Panoramic Sky background — looping video with static fallback
                    ZStack {
                        // Static fallback always rendered underneath
                        Image("sky_bg")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 110)
                            .frame(maxWidth: .infinity)
                            .clipped()
                        
                        // Looping video layer on top (hidden when Reduce Motion / Low Power)
                        if !reduceMotion && !ProcessInfo.processInfo.isLowPowerModeEnabled {
                            SkyLoopPlayer()
                                .frame(height: 110)
                                .frame(maxWidth: .infinity)
                                .clipped()
                        }
                    }
                    .allowsHitTesting(false)
                    
                    if !imageName.isEmpty {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 95)
                            .scaleEffect(scaleEffect)
                            .offset(y: floatOffset)
                            .id(imageName) // Force view identity change to trigger transition
                            .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    }
                }
                .frame(height: 110)
                .cornerRadius(Theme.Radius.md)
                .animation(.easeInOut(duration: 0.35), value: imageName) // Custom crossfade animation for image swap
                .onAppear {
                    if !reduceMotion {
                        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                            floatOffset = -6.0
                        }
                        if currentStep == 19 {
                            triggerZoomEffect()
                        }
                    }
                }
                .onChange(of: currentStep) { _, newValue in
                    if newValue == 19 && !reduceMotion {
                        triggerZoomEffect()
                    }
                }
                
                // Text progression indicator
                VStack(spacing: 2) {
                    Text("Step \(currentDoingStep) of 7")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color.theme.accentPrimary)
                        .textCase(.uppercase)
                    
                    Text(islandStepName)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 6)
            } else {
                EmptyView()
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentDoingStep)
    }
    
    private func triggerZoomEffect() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            scaleEffect = 1.35 // Zoom in
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                scaleEffect = 1.0 // Zoom out back to normal
            }
        }
    }
}

#Preview {
    ZStack {
        Color.theme.canvas.ignoresSafeArea()
        MoneyIslandProgressView(currentStep: 4)
    }
}
