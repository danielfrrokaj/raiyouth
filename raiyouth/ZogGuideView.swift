//
//  ZogGuideView.swift
//  raiyouth
//

import SwiftUI
import AVFoundation

// Custom Shape for Zog's Speech Bubble (squared bottom-left corner pointing toward Zog)
struct SpeechBubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius: CGFloat = 14
        
        // Start top-left corner
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                    radius: radius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        
        // Top-right corner
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                    radius: radius, startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 0), clockwise: false)
        
        // Bottom-right corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                    radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        
        // Bottom-left corner is squared (points toward Zog)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        
        path.closeSubpath()
        return path
    }
}

// Transparent Video Player wrapper using UIViewRepresentable
struct TransparentVideoPlayer: UIViewRepresentable {
    let videoName: String
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        guard let path = Bundle.main.path(forResource: videoName, ofType: "mov") else {
            // If file is not found, we don't crash, the fallback handles it
            return view
        }
        
        let url = URL(fileURLWithPath: path)
        let playerItem = AVPlayerItem(url: url)
        let queuePlayer = AVQueuePlayer(playerItem: playerItem)
        let playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        
        context.coordinator.player = queuePlayer
        context.coordinator.looper = playerLooper
        
        let playerLayer = AVPlayerLayer(player: queuePlayer)
        playerLayer.backgroundColor = UIColor.clear.cgColor
        playerLayer.videoGravity = .resizeAspect
        
        // Configure for transparent compositing
        playerLayer.pixelBufferAttributes = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
        
        // Listen to load events
        queuePlayer.isMuted = true
        view.layer.addSublayer(playerLayer)
        context.coordinator.playerLayer = playerLayer
        
        queuePlayer.play()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            context.coordinator.playerLayer?.frame = uiView.bounds
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var player: AVQueuePlayer?
        var looper: AVPlayerLooper?
        var playerLayer: AVPlayerLayer?
        
        deinit {
            player?.pause()
        }
    }
}

// Zog guide character's state/pose
enum ZogPose: String {
    case idle = "rai_idle"
    case wave = "rai_wave"
    case reassure = "rai_reassure"
    case cheer = "rai_cheer"
}

struct ZogGuideView: View {
    let pose: ZogPose
    let speechBubbleText: String?
    let isHeroSize: Bool // True for Welcome & Success, False for inline guides
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    
    // Checks if low power mode is active or video is missing
    private var usePosterFallback: Bool {
        if reduceMotion { return true }
        if ProcessInfo.processInfo.isLowPowerModeEnabled { return true }
        
        // Check if the video file actually exists in bundle
        let hasVideo = Bundle.main.path(forResource: pose.rawValue, ofType: "mov") != nil
        return !hasVideo
    }
    
    // Words verification according to Style Context (max 14 words)
    private var validatedSpeechText: String {
        guard let text = speechBubbleText else { return "" }
        let words = text.split(separator: " ")
        if words.count > 14 {
            // Crop to 14 words and add period
            let cropped = words.prefix(14).joined(separator: " ")
            return cropped.sentenceCased
        }
        return text.sentenceCased
    }
    
    var body: some View {
        if isHeroSize {
            // Large centered view for Welcome / Success
            VStack(spacing: Theme.Spacing.lg) {
                // Speech Bubble first
                if let text = speechBubbleText, !text.isEmpty {
                    bubbleView(text: validatedSpeechText)
                        .transition(.scale.combined(with: .opacity))
                }
                
                // Character image/video
                characterView
                    .frame(width: 260, height: 260)
            }
        } else {
            // Inline guide layout (top-left beside speech bubble)
            HStack(alignment: .top, spacing: Theme.Spacing.md) {
                characterView
                    .frame(width: 96, height: 96)
                
                if let text = speechBubbleText, !text.isEmpty {
                    bubbleView(text: validatedSpeechText)
                        .padding(.top, Theme.Spacing.xs)
                }
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private var characterView: some View {
        if usePosterFallback {
            Image(pose.rawValue)
                .resizable()
                .scaledToFit()
                .transition(.opacity)
        } else {
            TransparentVideoPlayer(videoName: pose.rawValue)
                .transition(.opacity)
        }
    }
    
    private func bubbleView(text: String) -> some View {
        Text(text)
            .themeFont(.caption)
            .foregroundColor(.theme.textPrimary)
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.vertical, Theme.Spacing.md)
            .background(
                SpeechBubbleShape()
                    .fill(reduceTransparency ? Color.theme.surface3 : Color.theme.glassFill)
            )
            .overlay(
                SpeechBubbleShape()
                    .stroke(Color.theme.glassBorder, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    ZogGuideView(pose: .wave, speechBubbleText: "welcome to raiyouth, your new digital wallet. let's get you set up!", isHeroSize: false)
        .padding()
        .background(Color.theme.canvas)
}
