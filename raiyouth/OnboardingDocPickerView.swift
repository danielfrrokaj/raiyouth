//
//  OnboardingDocPickerView.swift
//  raiyouth
//

import SwiftUI

struct OnboardingDocPickerView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    let onSkipKYC: () -> Void
    
    @State private var selectedType = "id"
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
            
            // Guided Character (Idle pose pointing to choices)
            ZogGuideView(
                pose: .idle,
                speechBubbleText: "Select which official document you have on hand right now.",
                isHeroSize: false
            )
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.md)
            .padding(.bottom, Theme.Spacing.md)
            
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                Text("Pick a document to upload")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.theme.textPrimary)
                
                Text("We need a valid document to confirm that you reside in \(data.countryOfResidence) and verify who you are. Data is processed securely.")
                    .themeFont(.caption)
                    .foregroundColor(.theme.textSecondary)
                    .lineSpacing(3)
                
                VStack(spacing: Theme.Spacing.md) {
                    // ID Card option card
                    Button(action: { selectedType = "id" }) {
                        HStack(spacing: Theme.Spacing.md) {
                            // Radio indicator
                            Circle()
                                .strokeBorder(selectedType == "id" ? Color.theme.accentPrimary : Color.white.opacity(0.15), lineWidth: 2)
                                .background(Circle().fill(selectedType == "id" ? Color.theme.accentPrimary : Color.clear).padding(4))
                                .frame(width: 22, height: 22)
                            
                            ZStack {
                                Circle()
                                    .fill(Color.theme.accentTeal.opacity(0.12))
                                    .frame(width: 42, height: 42)
                                Image(systemName: "person.text.rectangle.fill")
                                    .foregroundColor(.theme.accentTeal)
                            }
                            
                            Text("Identity card")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                                .fill(reduceTransparency ? Color.theme.surface2 : (selectedType == "id" ? Color.white.opacity(0.09) : Color.white.opacity(0.06)))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                                .stroke(selectedType == "id" ? Color.theme.accentPrimary : Color.white.opacity(0.1), lineWidth: selectedType == "id" ? 1.5 : 1)
                        )
                    }
                    .buttonStyle(CardButtonStyle())
                    
                    // Passport option card
                    Button(action: { selectedType = "passport" }) {
                        HStack(spacing: Theme.Spacing.md) {
                            Circle()
                                .strokeBorder(selectedType == "passport" ? Color.theme.accentPrimary : Color.white.opacity(0.15), lineWidth: 2)
                                .background(Circle().fill(selectedType == "passport" ? Color.theme.accentPrimary : Color.clear).padding(4))
                                .frame(width: 22, height: 22)

                            ZStack {
                                Circle()
                                    .fill(Color.theme.accentPrimary.opacity(0.12))
                                    .frame(width: 42, height: 42)
                                Image(systemName: "globe.desk.fill")
                                    .foregroundColor(.theme.accentPrimary)
                            }

                            Text("Passport")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)

                            Spacer()
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                                .fill(reduceTransparency ? Color.theme.surface2 : (selectedType == "passport" ? Color.white.opacity(0.09) : Color.white.opacity(0.06)))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                                .stroke(selectedType == "passport" ? Color.theme.accentPrimary : Color.white.opacity(0.1), lineWidth: selectedType == "passport" ? 1.5 : 1)
                        )
                    }
                    .buttonStyle(CardButtonStyle())

                    // Scan later option
                    Button(action: { selectedType = "later" }) {
                        HStack(spacing: Theme.Spacing.md) {
                            Circle()
                                .strokeBorder(selectedType == "later" ? Color.theme.warning : Color.white.opacity(0.15), lineWidth: 2)
                                .background(Circle().fill(selectedType == "later" ? Color.theme.warning : Color.clear).padding(4))
                                .frame(width: 22, height: 22)

                            ZStack {
                                Circle()
                                    .fill(Color.theme.warning.opacity(0.12))
                                    .frame(width: 42, height: 42)
                                Image(systemName: "clock.badge.questionmark.fill")
                                    .foregroundColor(.theme.warning)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Scan ID later")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("Your account will be limited until verified")
                                    .font(.system(size: 11))
                                    .foregroundColor(.theme.textSecondary)
                            }

                            Spacer()
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                                .fill(reduceTransparency ? Color.theme.surface2 : (selectedType == "later" ? Color.theme.warning.opacity(0.07) : Color.white.opacity(0.04)))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                                .stroke(selectedType == "later" ? Color.theme.warning.opacity(0.6) : Color.white.opacity(0.08), lineWidth: selectedType == "later" ? 1.5 : 1)
                        )
                    }
                    .buttonStyle(CardButtonStyle())
                }
                .padding(.top, Theme.Spacing.md)
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            Spacer()
            
            // Actions
            VStack(spacing: Theme.Spacing.md) {
                Button(action: {
                    data.selectedDocType = selectedType
                    if selectedType == "later" {
                        onSkipKYC()
                    } else {
                        onNext()
                    }
                }) {
                    Text(selectedType == "later" ? "Skip for now" : "Continue")
                }
                .buttonStyle(PremiumButtonStyle(isEnabled: true))

                Button(action: onBack) {
                    Text("Change your citizenship")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color.theme.accentTeal)
                }
                .padding(.vertical, 4)
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.xl)
        }
        .background(Color.theme.canvas.ignoresSafeArea())
        .ambientGlows()
    }
}

#Preview {
    OnboardingDocPickerView(data: .constant(OnboardingData()), onNext: {}, onBack: {}, onSkipKYC: {})
}
