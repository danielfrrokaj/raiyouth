import SwiftUI

struct OnboardingGuideIntroView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    var personaTitle: String { "Rai" }
    
    var personaDescription: String {
        "Rai is your personal money guide. As you build your island, verify your identity, and set up your wallet, Rai will be by your side, helping you save automatically and secure your assets."
    }
    
    var speechBubbleText: String {
        "Let's build your Money Island together!"
    }
    
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
            
            VStack(spacing: Theme.Spacing.xl) {
                // Larger Guide Character Centered
                ZogGuideView(
                    pose: .wave,
                    speechBubbleText: speechBubbleText,
                    isHeroSize: true
                )
                .padding(.top, Theme.Spacing.md)
                
                VStack(spacing: Theme.Spacing.md) {
                    Text("Meet Rai!")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.theme.textPrimary)
                    
                    Text(personaDescription)
                        .themeFont(.body)
                        .foregroundColor(.theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.Spacing.lg)
                }
                
                // Reward Badge
                HStack(spacing: 8) {
                    Image(systemName: "lock.open.fill")
                        .foregroundColor(.theme.accentPrimary)
                    Text("Guide Unlocked")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.theme.accentPrimary.opacity(0.15))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.theme.accentPrimary.opacity(0.3), lineWidth: 1)
                )
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            Spacer()
            
            // Continue Button
            Button(action: onNext) {
                Text("Meet my guide")
            }
            .buttonStyle(PremiumButtonStyle(isEnabled: true))
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.xl)
        }
        .background(Color.theme.canvas.ignoresSafeArea())
    }
}

#Preview {
    OnboardingGuideIntroView(data: .constant(OnboardingData(persona: "goal getter")), onNext: {}, onBack: {})
}
