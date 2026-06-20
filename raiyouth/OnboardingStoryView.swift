//
//  OnboardingStoryView.swift
//  raiyouth
//
//  Created for raiyouth onboarding storytelling.
//

import SwiftUI

struct OnboardingStoryView: View {
    let onNext: () -> Void
    let onBack: () -> Void
    
    @State private var animateItems = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .themeFont(.caption)
                    .foregroundColor(.theme.textSecondary)
                }
                Spacer()
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.xs)
            .padding(.bottom, Theme.Spacing.xs)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: Theme.Spacing.xl) {
                    // Title Header
                    VStack(spacing: 6) {
                        Text("Rai Needs You.")
                            .font(.system(size: 30, weight: .heavy, design: .rounded))
                            .foregroundColor(.theme.textPrimary)
                            .multilineTextAlignment(.center)

                        Text("Help him build his island from scratch.")
                            .themeFont(.body)
                            .foregroundColor(.theme.accentTeal)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, Theme.Spacing.md)

                    // Large Immersive Rai on Island Illustration
                    ZStack {
                        Circle()
                            .fill(Color.theme.accentPrimary.opacity(0.10))
                            .frame(width: 250, height: 250)
                            .blur(radius: 24)
                            .scaleEffect(animateItems ? 1.08 : 0.92)

                        Image("rai_intro_illustration")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 220, height: 220)
                    }
                    .frame(height: 240)
                    .padding(.vertical, Theme.Spacing.sm)

                    // Speech Bubble from Rai
                    HStack(alignment: .top, spacing: Theme.Spacing.md) {
                        Text("Hey! My island isn't going to build itself. Every step you take makes it bigger, stronger, and more epic. You in?")
                            .themeFont(.caption)
                            .foregroundColor(.theme.textPrimary)
                            .lineSpacing(3)
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
                    .padding(.horizontal, Theme.Spacing.lg)

                    // Mission Steps
                    VStack(alignment: .leading, spacing: 14) {
                        storyMilestoneRow(
                            icon: "hammer.fill",
                            title: "Raise the Signal Tower",
                            desc: "Set up your profile and plant your flag — the island starts taking shape."
                        )

                        storyMilestoneRow(
                            icon: "lock.shield.fill",
                            title: "Forge the Trust Gate",
                            desc: "Verify your identity and unlock Rai's most powerful island landmark."
                        )

                        storyMilestoneRow(
                            icon: "gift.fill",
                            title: "Open the Treasure Vault",
                            desc: "Claim a real cash bonus — dropped straight into your wallet. No tricks."
                        )
                    }
                    .padding(Theme.Spacing.lg)
                    .glassCard(radius: Theme.Radius.lg)
                    .padding(.horizontal, Theme.Spacing.lg)
                }
                .padding(.bottom, 24)
            }

            Spacer()

            Button(action: onNext) {
                Text("Let's Build!")
            }
            .buttonStyle(PremiumButtonStyle(isEnabled: true))
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.xl)
        }
        .background(Color.theme.canvas.ignoresSafeArea())
        .ambientGlows()
        .onAppear {
            if !reduceMotion {
                withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                    animateItems = true
                }
            } else {
                animateItems = true
            }
        }
    }
    
    private func storyMilestoneRow(icon: String, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color.theme.accentPrimary)
                .frame(width: 28, height: 28)
                .background(Color.theme.accentPrimary.opacity(0.12))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text(desc)
                    .font(.system(size: 12))
                    .foregroundColor(.theme.textSecondary)
                    .lineSpacing(2)
            }
        }
    }
}

#Preview {
    OnboardingStoryView(onNext: {}, onBack: {})
}
