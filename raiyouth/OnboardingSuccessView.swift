//
//  OnboardingSuccessView.swift
//  raiyouth
//

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
    
    @State private var showNextMission = false
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    
    var body: some View {
        ZStack {
            // Main Content
            VStack(spacing: Theme.Spacing.lg) {
                
                // Header Character
                ZStack {
                    if !reduceMotion {
                        Circle()
                            .fill(Color.theme.accentPrimary.opacity(0.12))
                            .frame(width: 180, height: 180)
                            .blur(radius: 25)
                            .scaleEffect(pulseScale)
                            .onAppear {
                                withAnimation(
                                    .easeInOut(duration: 1.2)
                                    .repeatForever(autoreverses: true)
                                ) {
                                    pulseScale = 1.35
                                }
                            }
                    }
                    
                    ZogGuideView(
                        pose: showNextMission ? .wave : .cheer,
                        speechBubbleText: showNextMission ?
                            "Welcome to your Quest Hub! Let's activate your account." :
                            (isVaultUnlocked ? "Congratulations! Your cash bonus is claimed." : "You unlocked a mystery vault! Tap to open your reward."),
                        isHeroSize: true
                    )
                }
                .padding(.top, Theme.Spacing.md)
                
                if !isVaultUnlocked {
                    // Mystery Vault Interactive Graphic
                    Spacer()
                    
                    Button(action: unlockVault) {
                        VStack(spacing: Theme.Spacing.md) {
                            ZStack {
                                // Glow ring behind chest
                                Circle()
                                    .fill(Color.theme.accentPrimary.opacity(0.08))
                                    .frame(width: 140, height: 140)
                                    .scaleEffect(vaultScale)
                                
                                // Frosted glass vault circle
                                Circle()
                                    .fill(reduceTransparency ? Color.theme.surface3 : Color.theme.glassFillStrong)
                                    .frame(width: 120, height: 120)
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
                                
                                // Lock graphic
                                Image(systemName: "lock.shield.fill")
                                    .font(.system(size: 50, weight: .bold))
                                    .foregroundColor(.theme.accentPrimary)
                                    .shadow(color: Color.theme.accentPrimary.opacity(0.5), radius: 10)
                            }
                            
                            Text("Claim your signup reward")
                                .themeFont(.title)
                                .foregroundColor(.theme.textPrimary)
                            
                            Text("Tap to open the vault")
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
                } else if !showNextMission {
                    // Vault Unlocked: Show Money Won & Details
                    VStack(spacing: Theme.Spacing.md) {
                        
                        // Cash won amount (32pt Display, tabular, tightened tracking)
                        VStack(spacing: 4) {
                            Text("You won")
                                .themeFont(.caption)
                                .foregroundColor(.theme.accentPrimary)
                                .padding(.horizontal, Theme.Spacing.md)
                                .padding(.vertical, 4)
                                .background(Color.theme.accentPrimary.opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.pill, style: .continuous))
                            
                            Text(String(format: "+%.2f €", data.signupRewardAmount))
                                .themeFont(.display(value: data.signupRewardAmount))
                                .foregroundColor(.theme.accentPrimary)
                                .scaleEffect(showDetails ? 1.0 : 0.5)
                                .opacity(showDetails ? 1.0 : 0.0)
                                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2), value: showDetails)
                        }
                        
                        // Setup Summary Card fading in
                        if showDetails {
                            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                                Text("Your setup summary")
                                    .themeFont(.title)
                                    .foregroundColor(.theme.textPrimary)
                                
                                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                                    HStack {
                                        Image(systemName: "flag.fill")
                                            .foregroundColor(.theme.accentPrimary)
                                            .frame(width: 24)
                                        Text(data.intent?.sentenceCased ?? "none")
                                            .themeFont(.body)
                                            .foregroundColor(.theme.textPrimary)
                                    }
                                    
                                    HStack {
                                        Image(systemName: "sparkles")
                                            .foregroundColor(.theme.accentTeal)
                                            .frame(width: 24)
                                        Text(data.persona?.sentenceCased ?? "none")
                                            .themeFont(.body)
                                            .foregroundColor(.theme.textPrimary)
                                    }
                                    
                                    HStack {
                                        Image(systemName: "creditcard.fill")
                                            .foregroundColor(.theme.accentPrimary)
                                            .frame(width: 24)
                                        Text(data.cardColor.sentenceCased)
                                            .themeFont(.body)
                                            .foregroundColor(.theme.textPrimary)
                                    }
                                }
                            }
                            .padding(Theme.Spacing.lg)
                            .glassCard(radius: Theme.Radius.lg)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.4), value: showDetails)
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.lg)
                    
                    Spacer()
                    
                    // Proceed to Level 2 transition
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showNextMission = true
                        }
                    }) {
                        Text("Continue")
                    }
                    .buttonStyle(PremiumButtonStyle(isEnabled: true))
                    .padding(.horizontal, Theme.Spacing.xxl)
                    .padding(.bottom, Theme.Spacing.xxl)
                } else {
                    // Level 2 Intro: "Your next mission"
                    VStack(spacing: Theme.Spacing.lg) {
                        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                            HStack {
                                Text("Good evening, \(data.firstName.sentenceCased)")
                                    .themeFont(.h2)
                                    .foregroundColor(.theme.textPrimary)
                                Spacer()
                            }
                            
                            HStack(spacing: 6) {
                                Image(systemName: "sparkles")
                                    .foregroundColor(.theme.accentPrimary)
                                Text("300 RaiPoints")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.theme.accentPrimary)
                            }
                            .padding(.horizontal, Theme.Spacing.md)
                            .padding(.vertical, 6)
                            .background(Color.theme.accentPrimary.opacity(0.12))
                            .cornerRadius(Theme.Radius.pill)
                            
                            // Mission Details Card
                            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                                Text("Your next mission")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.theme.accentTeal)
                                
                                Text("Add money to your account and start your journey!")
                                    .themeFont(.body)
                                    .foregroundColor(.theme.textPrimary)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Button(action: onFinish) {
                                    Text("Start mission")
                                }
                                .buttonStyle(PremiumButtonStyle(isEnabled: true))
                                .padding(.top, Theme.Spacing.sm)
                            }
                            .padding(Theme.Spacing.lg)
                            .glassCard(radius: Theme.Radius.lg)
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                    }
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    
                    Spacer()
                }
            }
            .background(Color.theme.canvas.ignoresSafeArea())
            
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
    
    private func unlockVault() {
        // Roll random reward between 10.00 and 25.00
        let amounts = [10.00, 15.00, 20.00, 25.00]
        let rolledAmount = amounts.randomElement() ?? 15.00
        
        // Save won amount
        data.signupRewardAmount = rolledAmount
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            isVaultUnlocked = true
        }
        
        triggerRewardEffect()
        
        // Stagger details presentation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                showDetails = true
            }
        }
    }
    
    private func triggerRewardEffect() {
        // Haptic Feedback
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        // Generate Confetti
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
