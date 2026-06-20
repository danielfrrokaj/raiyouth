//
//  OnboardingDOBView.swift
//  raiyouth
//

import SwiftUI

struct OnboardingDOBView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    @FocusState private var isFocused: Bool
    @State private var dobInput = ""
    
    var isValidDOB: Bool {
        // Date format must match DD/MM/YYYY and user must be older than 18 (e.g. 8 digits typed)
        let digits = dobInput.filter { $0.isNumber }
        return digits.count == 8
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
                pose: .reassure,
                speechBubbleText: "Thanks! We need this to personalize your experience.",
                isHeroSize: false
            )
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.md)
            .padding(.bottom, Theme.Spacing.lg)
            
            VStack(alignment: .leading, spacing: Theme.Spacing.xl) {
                Text("What's your date of birth?")
                    .themeFont(.h1)
                    .foregroundColor(.theme.textPrimary)
                
                // Revolut-like formatted input field
                VStack(alignment: .leading, spacing: 4) {
                    Text("Date of birth")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(isFocused ? .theme.accentPrimary : .theme.textSecondary)
                    
                    TextField("18 / 06 / 2002", text: $dobInput)
                        .focused($isFocused)
                        .keyboardType(.numberPad)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .tint(.theme.accentPrimary)
                        .onChange(of: dobInput) { oldValue, newValue in
                            formatDOB(newValue)
                        }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(isFocused ? .theme.accentPrimary : Color.white.opacity(0.15))
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .onAppear {
                isFocused = true
                if !data.dateOfBirth.isEmpty {
                    dobInput = data.dateOfBirth
                }
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
                data.dateOfBirth = dobInput
                data.signupRewardAmount += 30.0
                onNext()
            }) {
                Text("Continue")
            }
            .buttonStyle(PremiumButtonStyle(isEnabled: isValidDOB))
            .disabled(!isValidDOB)
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.lg)
        }
        .ambientGlows()
    }
    
    private func formatDOB(_ input: String) {
        let cleanInput = input.filter { $0.isNumber }
        var formatted = ""
        
        for (index, char) in cleanInput.enumerated() {
            if index == 2 {
                formatted += " / "
            } else if index == 4 {
                formatted += " / "
            }
            
            if index < 8 {
                formatted += String(char)
            }
        }
        
        dobInput = formatted
    }
}

#Preview {
    OnboardingDOBView(data: .constant(OnboardingData()), onNext: {}, onBack: {})
}
