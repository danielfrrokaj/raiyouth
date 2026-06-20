//
//  OnboardingKYCOptionsView.swift
//  raiyouth
//

import SwiftUI

struct OnboardingKYCOptionsView: View {
    @Binding var data: OnboardingData
    let onSelectMethod: (String) -> Void // "database" vs "documents"
    let onBack: () -> Void
    
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
            
            // Guided Character (Reassuring pose)
            ZogGuideView(
                pose: .reassure,
                speechBubbleText: "Verify your identity to keep your account safe.",
                isHeroSize: false
            )
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.md)
            .padding(.bottom, Theme.Spacing.md)
            
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                Text("Verify your identity")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.theme.textPrimary)
                
                VStack(spacing: Theme.Spacing.md) {
                    // Option 1: Government Portal (Teal highlighted)
                    Button(action: {
                        onSelectMethod("database")
                    }) {
                        HStack(alignment: .top, spacing: Theme.Spacing.md) {
                            ZStack {
                                Circle()
                                    .fill(Color.theme.accentTeal.opacity(0.12))
                                    .frame(width: 44, height: 44)
                                
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.theme.accentTeal)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Verify using government portal")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                
                                Text("Instant and no-hassle verification using the official government platform.")
                                    .font(.system(size: 13))
                                    .foregroundColor(.theme.textSecondary)
                                    .lineSpacing(2)
                                    .multilineTextAlignment(.leading)
                                
                                // Faster Badge
                                Text("⚡ Faster")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color.theme.accentTeal)
                                    .cornerRadius(Theme.Radius.pill)
                                    .padding(.top, 2)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.theme.textTertiary)
                                .padding(.top, 4)
                        }
                        .padding(Theme.Spacing.lg)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                                .fill(reduceTransparency ? Color.theme.surface2 : Color.white.opacity(0.06))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                                .strokeBorder(Color.theme.accentTeal.opacity(0.4), lineWidth: 1.5)
                        )
                    }
                    .buttonStyle(CardButtonStyle())
                    
                    // Option 2: Upload Documents
                    Button(action: {
                        onSelectMethod("documents")
                    }) {
                        HStack(alignment: .top, spacing: Theme.Spacing.md) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.08))
                                    .frame(width: 44, height: 44)
                                
                                Image(systemName: "doc.text.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Verify using documents")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                
                                Text("Upload a photo of your identity document (ID card or passport) manually.")
                                    .font(.system(size: 13))
                                    .foregroundColor(.theme.textSecondary)
                                    .lineSpacing(2)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.theme.textTertiary)
                                .padding(.top, 4)
                        }
                        .padding(Theme.Spacing.lg)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                                .fill(reduceTransparency ? Color.theme.surface2 : Color.white.opacity(0.06))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                                .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                        )
                    }
                    .buttonStyle(CardButtonStyle())
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            Spacer()
        }
        .background(Color.theme.canvas.ignoresSafeArea())
        .ambientGlows()
    }
}

#Preview {
    OnboardingKYCOptionsView(data: .constant(OnboardingData()), onSelectMethod: { _ in }, onBack: {})
}
