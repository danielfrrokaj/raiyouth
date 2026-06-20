//
//  OnboardingCountryView.swift
//  raiyouth
//

import SwiftUI

struct OnboardingCountryView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
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
            
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                Text("Country of residence")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.theme.textPrimary)
                    .padding(.top, Theme.Spacing.lg)
                
                Text("The terms and services which apply to you will depend on your country of residence")
                    .themeFont(.caption)
                    .foregroundColor(.theme.textSecondary)
                    .lineSpacing(3)
                
                // Select Box
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Country")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.theme.textSecondary)
                        Text("\(data.countryOfResidence) 🇦🇱")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.theme.textSecondary)
                }
                .padding(.horizontal, 16)
                .frame(height: 58)
                .background(Color.white.opacity(0.06))
                .cornerRadius(Theme.Radius.md)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.md)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .padding(.top, Theme.Spacing.md)
                
                Spacer()
                
                // Legal disclaimer footer
                VStack(spacing: 6) {
                    Text("By pressing Sign up securely, you agree to our ")
                        .foregroundColor(.theme.textTertiary)
                    + Text("Terms & Conditions")
                        .foregroundColor(Color.theme.accentTeal)
                    + Text(" and ")
                        .foregroundColor(.theme.textTertiary)
                    + Text("Privacy Policy")
                        .foregroundColor(Color.theme.accentTeal)
                    + Text(". Digital-only support available 24/7 via the in-app chat. Your data will be securely encrypted with TLS 🔒")
                        .foregroundColor(.theme.textTertiary)
                }
                .font(.system(size: 11))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.bottom, Theme.Spacing.md)
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            // Secure Sign Up Button
            Button(action: onNext) {
                Text("Sign up securely")
            }
            .buttonStyle(PremiumButtonStyle(isEnabled: true))
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.xl)
        }
        .background(Color.theme.canvas.ignoresSafeArea())
    }
}

#Preview {
    OnboardingCountryView(data: .constant(OnboardingData()), onNext: {}, onBack: {})
}
