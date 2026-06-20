//
//  OnboardingCitizenshipView.swift
//  raiyouth
//

import SwiftUI

struct OnboardingCitizenshipView: View {
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
                Text("Are you a citizen of Albania?")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.theme.textPrimary)
                    .padding(.top, Theme.Spacing.lg)
                
                Text("We need this information to open your RaiYouth account.")
                    .themeFont(.caption)
                    .foregroundColor(.theme.textSecondary)
                
                Spacer()
                
                // Centered circular glossy flag graphic
                HStack {
                    Spacer()
                    ZStack {
                        // Glossy backdrop shadow
                        Circle()
                            .fill(Color.red.opacity(0.12))
                            .frame(width: 220, height: 220)
                            .blur(radius: 20)
                        
                        // Main circle
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#E52D27"), Color(hex: "#B31217")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 170, height: 170)
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.3), Color.white.opacity(0.05)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )
                        
                        // Albanian Eagle symbol / Flag representation
                        VStack(spacing: 4) {
                            Text("🇦🇱")
                                .font(.system(size: 80))
                                .shadow(color: Color.black.opacity(0.2), radius: 6)
                        }
                    }
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            // Action Buttons
            HStack(spacing: Theme.Spacing.md) {
                Button(action: {
                    data.isCitizen = false
                    onNext()
                }) {
                    Text("No")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
                                .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
                        )
                }
                
                Button(action: {
                    data.isCitizen = true
                    onNext()
                }) {
                    Text("Yes")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.theme.textOnAccentYellow)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.theme.accentPrimary)
                        .cornerRadius(Theme.Radius.md)
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.xl)
        }
        .background(Color.theme.canvas.ignoresSafeArea())
    }
}

#Preview {
    OnboardingCitizenshipView(data: .constant(OnboardingData()), onNext: {}, onBack: {})
}
