//
//  VideoIntroView.swift
//  raiyouth
//

import SwiftUI
import AVFoundation

struct VideoIntroView: UIViewRepresentable {
    let videoName: String
    let onFinished: () -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        
        guard let path = Bundle.main.path(forResource: videoName, ofType: "mp4") else {
            // Graceful fallback if video file is missing or failed to compile
            print("Warning: Intro video file '\(videoName).mp4' not found in main bundle.")
            DispatchQueue.main.async {
                onFinished()
            }
            return view
        }
        
        let url = URL(fileURLWithPath: path)
        let player = AVPlayer(url: url)
        context.coordinator.player = player
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        context.coordinator.playerLayer = playerLayer
        
        // Listen to playback completion
        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(Coordinator.playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
        
        // Play the video
        player.play()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            context.coordinator.playerLayer?.frame = uiView.bounds
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onFinished: onFinished)
    }
    
    class Coordinator: NSObject {
        var player: AVPlayer?
        var playerLayer: AVPlayerLayer?
        let onFinished: () -> Void
        
        init(onFinished: @escaping () -> Void) {
            self.onFinished = onFinished
        }
        
        @objc func playerDidFinishPlaying() {
            DispatchQueue.main.async {
                self.onFinished()
            }
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    }
}
