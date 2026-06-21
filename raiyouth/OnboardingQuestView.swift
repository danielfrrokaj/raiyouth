import SwiftUI

struct OnboardingQuestView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    let quests = [
        QuestData(
            id: "save",
            intent: "Save for something cool",
            persona: "goal getter",
            emoji: "🎯",
            description: "Set savings targets and build habits to reach your goals faster."
        ),
        QuestData(
            id: "spend",
            intent: "Spend smarter",
            persona: "smart spender",
            emoji: "📊",
            description: "Track your spending automatically and budget without the stress."
        ),
        QuestData(
            id: "learn",
            intent: "Learn money skills",
            persona: "explorer",
            emoji: "💡",
            description: "Master compound interest, stocks, and build strong financial roots."
        ),
        QuestData(
            id: "card",
            intent: "Get my first card",
            persona: "card starter",
            emoji: "💳",
            description: "Forge a customized card that matches your unique vibe and style."
        )
    ]
    
    struct QuestData: Identifiable {
        let id: String
        let intent: String
        let persona: String
        let emoji: String
        let description: String
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
            
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                Text("Choose your first quest")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.theme.textPrimary)
                    .padding(.top, Theme.Spacing.lg)
                
                Text("Pick why you're joining RaiYouth. This personalises your dashboard and goals.")
                    .themeFont(.caption)
                    .foregroundColor(.theme.textSecondary)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: Theme.Spacing.md) {
                        ForEach(quests) { quest in
                            let isSelected = data.intent == quest.intent
                            
                            Button(action: {
                                withAnimation(.spring(response: 0.22, dampingFraction: 0.8)) {
                                    data.intent = quest.intent
                                    data.persona = quest.persona
                                }
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }) {
                                HStack(spacing: 16) {
                                    Text(quest.emoji)
                                        .font(.system(size: 30))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(quest.intent.sentenceCased)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(isSelected ? .theme.accentPrimary : .white)
                                        
                                        Text(quest.description)
                                            .themeFont(.caption)
                                            .foregroundColor(isSelected ? .white.opacity(0.8) : .theme.textSecondary)
                                            .multilineTextAlignment(.leading)
                                    }
                                    
                                    Spacer()
                                    
                                    if isSelected {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.theme.accentPrimary)
                                            .font(.system(size: 20))
                                    }
                                }
                                .padding(16)
                                .background(Color.theme.surfaceCard)
                                .background(isSelected ? Color.theme.accentPrimary.opacity(0.08) : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                                        .strokeBorder(
                                            isSelected ?
                                            Color.theme.accentPrimary :
                                            Color.white.opacity(0.12),
                                            lineWidth: isSelected ? 2 : 1
                                        )
                                )
                                .scaleEffect(isSelected ? 1.01 : 1.0)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            Spacer()
            
            // Continue Button
            Button(action: onNext) {
                Text("Continue")
            }
            .buttonStyle(PremiumButtonStyle(isEnabled: data.intent != nil))
            .disabled(data.intent == nil)
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.xl)
        }
        .background(Color.theme.canvas.ignoresSafeArea())
    }
}

#Preview {
    OnboardingQuestView(data: .constant(OnboardingData()), onNext: {}, onBack: {})
}
