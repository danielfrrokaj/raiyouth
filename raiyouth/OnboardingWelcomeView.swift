//
//  OnboardingWelcomeView.swift
//  raiyouth
//

import SwiftUI

struct OnboardingWelcomeView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    
    @FocusState private var activeField: Field?
    
    enum Field {
        case firstName, lastName, phoneNumber
    }
    
    var isFormValid: Bool {
        !data.firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !data.lastName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !data.phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Small inline Zog guide at the top to save screen space
            ZogGuideView(
                pose: .wave,
                speechBubbleText: "Great! Let's start with your basic information.",
                isHeroSize: false
            )
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.md)
            .padding(.bottom, Theme.Spacing.lg)
            
            VStack(alignment: .leading, spacing: Theme.Spacing.xl) {
                Text("Let's get to know you")
                    .themeFont(.h1)
                    .foregroundColor(.theme.textPrimary)
                
                // Revolut-like clean input fields direct on canvas
                VStack(spacing: Theme.Spacing.lg) {
                    
                    // Name Field
                    VStack(alignment: .leading, spacing: 4) {
                        Text("First name")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(activeField == .firstName ? .theme.accentPrimary : .theme.textSecondary)
                        
                        TextField("Enter your name", text: $data.firstName)
                            .focused($activeField, equals: .firstName)
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .tint(.theme.accentPrimary)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(activeField == .firstName ? .theme.accentPrimary : Color.white.opacity(0.15))
                    }
                    
                    // Surname Field
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Last name")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(activeField == .lastName ? .theme.accentPrimary : .theme.textSecondary)
                        
                        TextField("Enter your surname", text: $data.lastName)
                            .focused($activeField, equals: .lastName)
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .tint(.theme.accentPrimary)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(activeField == .lastName ? .theme.accentPrimary : Color.white.opacity(0.15))
                    }
                    
                    // Phone Number Field
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Phone number")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(activeField == .phoneNumber ? .theme.accentPrimary : .theme.textSecondary)
                        
                        HStack(spacing: Theme.Spacing.sm) {
                            // Country Code selector
                            HStack(spacing: 4) {
                                Text("🇽🇰")
                                Text("+383")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.theme.textPrimary)
                            }
                            .padding(.vertical, 8)
                            
                            TextField("123 456", text: $data.phoneNumber)
                                .focused($activeField, equals: .phoneNumber)
                                .keyboardType(.numberPad)
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .tint(.theme.accentPrimary)
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(activeField == .phoneNumber ? .theme.accentPrimary : Color.white.opacity(0.15))
                    }
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            Spacer()
            
            // Sub-Reward badge
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .foregroundColor(.theme.accentPrimary)
                    .font(.system(size: 14, weight: .bold))
                Text("+20 RaiPoints")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.theme.accentPrimary)
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, 6)
            .background(Color.theme.accentPrimary.opacity(0.12))
            .cornerRadius(Theme.Radius.pill)
            .padding(.bottom, Theme.Spacing.lg)
            
            // Primary Action Button (SOLID yellow)
            Button(action: {
                data.signupRewardAmount += 20.0
                onNext()
            }) {
                Text("Continue")
            }
            .buttonStyle(PremiumButtonStyle(isEnabled: isFormValid))
            .disabled(!isFormValid)
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.lg)
        }
        .ambientGlows()
    }
}

#Preview {
    OnboardingWelcomeView(data: .constant(OnboardingData()), onNext: {})
}
