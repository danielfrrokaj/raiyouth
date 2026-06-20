//
//  OnboardingTermsView.swift
//  raiyouth
//

import SwiftUI

struct OnboardingTermsView: View {
    let onAccept: () -> Void
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
                speechBubbleText: "Please accept Onfido's terms of service to scan your document.",
                isHeroSize: false
            )
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.md)
            .padding(.bottom, Theme.Spacing.md)
            
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                Text("Verify your identity")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.theme.textPrimary)
                
                Text("Notice, release, and acceptance of Onfido's facial scan and voice recording policy and terms of service")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .lineSpacing(3)
                
                // Scrollable Terms Box styled as a premium Glass Card
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Who is Onfido?")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Onfido Inc. (\"Onfido\") provides identity verification services to corporate clients, including the company that owns or operates the website or app that you are using or is providing the services you wish to access (\"Company\").")
                            .font(.system(size: 13))
                            .foregroundColor(.theme.textSecondary)
                            .lineSpacing(4)
                        
                        Text("What checks will Onfido perform?")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("When you submit photos/videos of your face or audio recordings of your voice, Onfido will collect, process, use, and store data from such photos/videos and audio recordings, including data to the extent construed as a facial scan or biometric identifier.")
                            .font(.system(size: 13))
                            .foregroundColor(.theme.textSecondary)
                            .lineSpacing(4)
                        
                        Text("How long will Onfido retain my data?")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Onfido securely stores and uses Scan Data for a maximum of 360 days after submission, or a shorter period set by the Company, after which it permanently destroys your Scan Data. Onfido securely stores raw photo/video assets for up to three years, after which they are permanently destroyed.")
                            .font(.system(size: 13))
                            .foregroundColor(.theme.textSecondary)
                            .lineSpacing(4)
                        
                        Text("By pressing Accept or continuing to use this service, you agree you have read, understand, and accept Onfido's facial scan policy and terms of service.")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.theme.textPrimary)
                            .lineSpacing(4)
                    }
                    .padding(Theme.Spacing.md)
                }
                .frame(maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                        .fill(reduceTransparency ? Color.theme.surface2 : Color.white.opacity(0.04))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                )
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            // Accept / Reject Buttons
            VStack(spacing: Theme.Spacing.md) {
                Button(action: onAccept) {
                    Text("Accept")
                }
                .buttonStyle(PremiumButtonStyle(isEnabled: true))
                .padding(.top, Theme.Spacing.md)
                
                Button(action: onBack) {
                    Text("Do not accept")
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
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.xl)
        }
        .background(Color.theme.canvas.ignoresSafeArea())
        .ambientGlows()
    }
}

#Preview {
    OnboardingTermsView(onAccept: {}, onBack: {})
}
