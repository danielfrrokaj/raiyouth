//
//  OnboardingEmailView.swift
//  raiyouth
//

import SwiftUI

struct OnboardingEmailView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    @FocusState private var isFocused: Bool
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: data.email)
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
            
            // Inline Zog Guide
            ZogGuideView(
                pose: .wave,
                speechBubbleText: "Almost there! Just a few more steps.",
                isHeroSize: false
            )
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.md)
            .padding(.bottom, Theme.Spacing.lg)
            
            VStack(alignment: .leading, spacing: Theme.Spacing.xl) {
                Text("What's your email?")
                    .themeFont(.h1)
                    .foregroundColor(.theme.textPrimary)
                
                // Revolut-like clean textfield direct on canvas
                VStack(alignment: .leading, spacing: 4) {
                    Text("Email")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(isFocused ? .theme.accentPrimary : .theme.textSecondary)
                    
                    TextField("marsida@gmail.com", text: $data.email)
                        .focused($isFocused)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .tint(.theme.accentPrimary)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(isFocused ? .theme.accentPrimary : Color.white.opacity(0.15))
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .onAppear {
                isFocused = true
            }
            
            Spacer()
            
            // Sub-Reward badge
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .foregroundColor(.theme.accentPrimary)
                    .font(.system(size: 14, weight: .bold))
                Text("+30 RaiPoints")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.theme.accentPrimary)
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, 6)
            .background(Color.theme.accentPrimary.opacity(0.12))
            .cornerRadius(Theme.Radius.pill)
            .padding(.bottom, Theme.Spacing.lg)
            
            // Continue Button (SOLID yellow)
            Button(action: {
                data.signupRewardAmount += 30.0
                onNext()
            }) {
                Text("Continue")
            }
            .buttonStyle(PremiumButtonStyle(isEnabled: isValidEmail))
            .disabled(!isValidEmail)
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.lg)
        }
        .ambientGlows()
    }
}

#Preview {
    OnboardingEmailView(data: .constant(OnboardingData()), onNext: {}, onBack: {})
}
