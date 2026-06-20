//
//  OnboardingPersonaView.swift
//  raiyouth
//

import SwiftUI

struct OnboardingPersonaView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    let personas = [
        "the hustler": "You earn side cash, sell designs, and want to invoice clients.",
        "the saver": "You stash money away, track compound interest, and love milestones.",
        "the explorer": "You spend on travel, gigs, food, and need instant local tracking."
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Back Button and Navigation
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
            .padding(.top, Theme.Spacing.sm)
            
            // Inline guide layout: Zog is smaller and inline
            ZogGuideView(
                pose: .idle,
                speechBubbleText: "Tell me your vibe. I will tune your dashboard to fit.",
                isHeroSize: false
            )
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.md)
            
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                Text("Choose your financial vibe")
                    .themeFont(.h2)
                    .foregroundColor(.theme.textPrimary)
                    .padding(.top, Theme.Spacing.lg)
                
                // Grid or list of options
                VStack(spacing: Theme.Spacing.md) {
                    ForEach(Array(personas.keys.sorted()), id: \.self) { key in
                        let desc = personas[key] ?? ""
                        Button(action: {
                            withAnimation(.spring(response: 0.22, dampingFraction: 0.8)) {
                                data.persona = key
                            }
                        }) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                                    Text(key.sentenceCased)
                                        .themeFont(.title)
                                        .foregroundColor(data.persona == key ? .theme.accentPrimary : .theme.textPrimary)
                                    Text(desc)
                                        .themeFont(.caption)
                                        .foregroundColor(data.persona == key ? .theme.textPrimary : .theme.textSecondary)
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer()
                                if data.persona == key {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.theme.accentPrimary)
                                        .font(.system(size: 20))
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.lg)
                            .padding(.vertical, Theme.Spacing.md)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.theme.surfaceCard)
                            .background(data.persona == key ? Color.theme.accentPrimary.opacity(0.10) : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
                            .overlay {
                                let borderGradient = data.persona == key
                                    ? LinearGradient(colors: [Color.theme.accentPrimary, Color.theme.accentPrimaryDeep], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    : LinearGradient(colors: [Color.white.opacity(0.20), Color.white.opacity(0.04)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                                    .stroke(borderGradient, lineWidth: data.persona == key ? 2 : 1)
                            }
                            .scaleEffect(data.persona == key ? 1.02 : 1.0)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            Spacer()
            
            // Primary button (SOLID yellow)
            Button(action: onNext) {
                Text("Continue")
            }
            .buttonStyle(PremiumButtonStyle(isEnabled: data.persona != nil))
            .disabled(data.persona == nil)
            .padding(.horizontal, Theme.Spacing.xxl)
            .padding(.bottom, Theme.Spacing.xxl)
        }
        .ambientGlows()
    }
}

#Preview {
    OnboardingPersonaView(data: .constant(OnboardingData()), onNext: {}, onBack: {})
}
