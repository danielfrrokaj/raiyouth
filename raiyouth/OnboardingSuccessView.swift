import SwiftUI

// Confetti Particle model
struct Particle: Identifiable {
    let id = UUID()
    let color: Color
    let size: CGFloat
    var x: CGFloat
    var y: CGFloat
    var rotation: Double
    var opacity: Double
}

struct OnboardingSuccessView: View {
    @Binding var data: OnboardingData
    let onFinish: () -> Void
    
    @State private var particles: [Particle] = []
    @State private var pulseScale: CGFloat = 1.0
    @State private var vaultScale: CGFloat = 1.0
    @State private var isVaultUnlocked = false
    @State private var showDetails = false
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    
    var body: some View {
        ZStack {
            Color.theme.canvas.ignoresSafeArea()
            
            // Main Content
            VStack(spacing: Theme.Spacing.md) {
                // Large character guide cheering
                ZogGuideView(
                    pose: .cheer,
                    speechBubbleText: isVaultUnlocked ?
                        "Perfect! Your Money Island is complete." :
                        "Your island is ready! Open the vault to claim your reward.",
                    isHeroSize: true
                )
                .padding(.top, Theme.Spacing.md)
                
                if !isVaultUnlocked {
                    Spacer()
                    
                    // Mystery Vault Interactive Graphic
                    Button(action: unlockVault) {
                        VStack(spacing: Theme.Spacing.md) {
                            ZStack {
                                Circle()
                                    .fill(Color.theme.accentPrimary.opacity(0.08))
                                    .frame(width: 130, height: 130)
                                    .scaleEffect(vaultScale)
                                
                                Circle()
                                    .fill(reduceTransparency ? Color.theme.surface3 : Color.theme.glassFillStrong)
                                    .frame(width: 110, height: 110)
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [Color.white.opacity(0.3), Color.white.opacity(0.05)],
                                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1
                                            )
                                    )
                                
                                Image("gift-3d")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 76, height: 76)
                                    .shadow(color: Color.theme.accentPrimary.opacity(0.3), radius: 8)
                            }
                            
                            Text("Claim your signup reward")
                                .themeFont(.title)
                                .foregroundColor(.theme.textPrimary)
                            
                            Text("Tap to unlock the vault")
                                .themeFont(.caption)
                                .foregroundColor(.theme.textSecondary)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .scaleEffect(vaultScale)
                    .onAppear {
                        if !reduceMotion {
                            withAnimation(
                                .easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true)
                            ) {
                                vaultScale = 1.05
                            }
                        }
                    }
                    
                    Spacer()
                } else {
                    // Vault Unlocked: Reward
                    VStack(spacing: Theme.Spacing.lg) {
                        Spacer()

                        // Reward Amount
                        VStack(spacing: 12) {
                            Text("Signup Bonus")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.theme.accentPrimary)
                                .kerning(1.4)
                                .textCase(.uppercase)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 5)
                                .background(Color.theme.accentPrimary.opacity(0.12))
                                .clipShape(Capsule())

                            Text(String(format: "+%.2f €", data.signupRewardAmount))
                                .font(.system(size: 56, weight: .heavy, design: .rounded))
                                .foregroundColor(.theme.accentPrimary)

                            Text("Deposited into your wallet")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.theme.textSecondary)
                        }
                        .padding(.top, 8)

                        Spacer()

                        // Enter My App CTA
                        Button(action: onFinish) {
                            Text("Enter my app")
                        }
                        .buttonStyle(PremiumButtonStyle(isEnabled: true))
                        .padding(.horizontal, Theme.Spacing.lg)
                        .padding(.bottom, Theme.Spacing.xl)
                    }
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            // Confetti Overlay
            if !reduceMotion {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .position(x: particle.x, y: particle.y)
                        .rotationEffect(.degrees(particle.rotation))
                        .opacity(particle.opacity)
                }
                .ignoresSafeArea()
            }
        }
    }
    
    private func summaryRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(Color.theme.accentPrimary)
                .frame(width: 20, height: 20)
                .background(Color.theme.accentPrimary.opacity(0.12))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                Text(value.sentenceCased)
                    .font(.system(size: 11))
                    .foregroundColor(Color.theme.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color.theme.success)
                .font(.system(size: 15))
        }
    }
    
    private func unlockVault() {
        let amounts = [10.00, 15.00, 20.00, 25.00]
        let rolledAmount = amounts.randomElement() ?? 15.00
        data.signupRewardAmount = rolledAmount
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            isVaultUnlocked = true
        }
        
        triggerRewardEffect()
    }
    
    private func triggerRewardEffect() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        if !reduceMotion {
            let colors = [
                Color.theme.accentPrimary,
                Color.theme.accentPrimaryDeep,
                Color.theme.accentTeal,
                Color.white
            ]
            
            var newParticles: [Particle] = []
            for _ in 0..<50 {
                let p = Particle(
                    color: colors.randomElement()!,
                    size: CGFloat.random(in: 6...12),
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: -20,
                    rotation: Double.random(in: 0...360),
                    opacity: 1.0
                )
                newParticles.append(p)
            }
            particles = newParticles
            
            withAnimation(.easeOut(duration: 3.0)) {
                for index in 0..<particles.count {
                    particles[index].y = UIScreen.main.bounds.height + 20
                    particles[index].x += CGFloat.random(in: -100...100)
                    particles[index].rotation += Double.random(in: 180...720)
                    particles[index].opacity = 0.0
                }
            }
        }
    }
}

#Preview {
    OnboardingSuccessView(data: .constant(OnboardingData(intent: "save money", persona: "the saver", cardColor: "teal", firstName: "Daniel", lastName: "")), onFinish: {})
}
