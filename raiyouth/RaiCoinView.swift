import SwiftUI

/// Rai coin with flip + shine effects.
/// - `size`: diameter of the coin
/// - `isAnimating`: set to true externally to trigger a flip+shine (e.g. when points are added)
struct RaiCoinView: View {
    var size: CGFloat = 32
    var isAnimating: Bool = false

    @State private var flipDegrees: Double = 0
    @State private var shineOffset: CGFloat = -1
    @State private var shineOpacity: Double = 0
    @State private var scale: CGFloat = 1

    var body: some View {
        ZStack {
            Image("raipoints")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .rotation3DEffect(.degrees(flipDegrees), axis: (x: 0, y: 1, z: 0))

            // Shine sweep overlay
            GeometryReader { geo in
                LinearGradient(
                    colors: [
                        Color.white.opacity(0),
                        Color.white.opacity(0.7),
                        Color.white.opacity(0)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: geo.size.width * 0.5)
                .offset(x: geo.size.width * shineOffset)
                .opacity(shineOpacity)
                .blendMode(.screen)
                .allowsHitTesting(false)
            }
            .frame(width: size, height: size)
            .clipShape(Circle())
        }
        .scaleEffect(scale)
        .frame(width: size, height: size)
        .onTapGesture { triggerAnimation() }
        .onChange(of: isAnimating) { newVal in
            if newVal { triggerAnimation() }
        }
    }

    private func triggerAnimation() {
        // Flip
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            scale = 1.15
        }
        withAnimation(.easeInOut(duration: 0.45)) {
            flipDegrees = 180
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            flipDegrees = 0
            withAnimation(.spring(response: 0.3, dampingFraction: 0.65)) {
                scale = 1
            }
        }

        // Shine sweep
        shineOffset = -1
        shineOpacity = 0
        withAnimation(.easeIn(duration: 0.15)) {
            shineOpacity = 1
        }
        withAnimation(.easeInOut(duration: 0.4)) {
            shineOffset = 1.5
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeOut(duration: 0.15)) {
                shineOpacity = 0
            }
        }
    }
}
