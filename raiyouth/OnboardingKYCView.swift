//
//  OnboardingKYCView.swift
//  raiyouth
//

import SwiftUI

struct OnboardingKYCView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    enum KYCPhase {
        case inputs
        case scanning
        case success
    }
    
    @State private var currentPhase: KYCPhase = .inputs
    @State private var laserOffset: CGFloat = -100
    @State private var scanProgress: Double = 0.0
    
    @FocusState private var focusedField: Field?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    
    enum Field {
        case name
        case id
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    if currentPhase == .scanning {
                        withAnimation { currentPhase = .inputs }
                    } else {
                        onBack()
                    }
                }) {
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
            
            // Inline guide updating based on phase
            ZogGuideView(
                pose: currentPhase == .scanning ? .idle : .reassure,
                speechBubbleText: currentPhase == .scanning ?
                    "Hold your document steady in the frame." :
                    "Just a quick check to keep your new account safe.",
                isHeroSize: false
            )
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.md)
            
            // Main Content Area with transition animations
            ZStack {
                if currentPhase == .inputs {
                    inputsView
                        .transition(reduceMotion ? .opacity : .move(edge: .leading))
                } else {
                    scannerView
                        .transition(reduceMotion ? .opacity : .move(edge: .trailing))
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: currentPhase)
            
            Spacer()
            
            // Primary button (SOLID yellow) - hidden during scanning
            if currentPhase == .inputs {
                // Sub-Reward badge
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .foregroundColor(.theme.accentPrimary)
                        .font(.system(size: 14, weight: .bold))
                    Text("+100 RaiPoints")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(.theme.accentPrimary)
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, 6)
                .background(Color.theme.accentPrimary.opacity(0.12))
                .cornerRadius(Theme.Radius.pill)
                .padding(.bottom, Theme.Spacing.md)
                
                Button(action: startScanning) {
                    Text("Verify account")
                }
                .buttonStyle(PremiumButtonStyle(isEnabled: isValid))
                .disabled(!isValid)
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.bottom, Theme.Spacing.lg)
            }
        }
        .ambientGlows()
        .onAppear {
            if currentPhase == .inputs {
                focusedField = .id // Focus document number first since name is read-only
            }
        }
    }
    
    // Phase 1: Inputs View
    private var inputsView: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Verify your identity")
                .themeFont(.h2)
                .foregroundColor(.theme.textPrimary)
                .padding(.top, Theme.Spacing.lg)
            
            // Form Card
            VStack(spacing: Theme.Spacing.lg) {
                // Name Input
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("Full name")
                        .themeFont(.caption)
                        .foregroundColor(.theme.textSecondary)
                    
                    HStack {
                        Text(data.fullName)
                            .themeFont(.body)
                            .foregroundColor(.theme.textPrimary)
                        Spacer()
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                    .frame(height: 44)
                    .background(Color.theme.surface3)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.sm, style: .continuous)
                            .stroke(Color.theme.glassBorder, lineWidth: 1)
                    )
                }
                
                // Document Number Input
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("Document number (ID card / passport)")
                        .themeFont(.caption)
                        .foregroundColor(.theme.textSecondary)
                    
                    TextField("E.g. A12345678B", text: $data.idNumber)
                        .themeFont(.body)
                        .foregroundColor(.theme.textPrimary)
                        .focused($focusedField, equals: .id)
                        .padding(.horizontal, Theme.Spacing.md)
                        .frame(height: 44)
                        .background(Color.theme.surface3)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.sm, style: .continuous)
                                .stroke(focusedField == .id ? Color.theme.accentPrimary : Color.theme.glassBorder, lineWidth: 1)
                        )
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                }
                
                // Reassurance disclaimer (min contrast 4.5:1 enforced)
                HStack(alignment: .top, spacing: Theme.Spacing.sm) {
                    Image(systemName: "lock.shield.fill")
                        .foregroundColor(.theme.accentTeal)
                        .font(.system(size: 16))
                        .padding(.top, 2)
                    
                    Text("Your data is encrypted end-to-end and stored securely. We never share your details without your consent.")
                        .themeFont(.caption)
                        .foregroundColor(.theme.textPrimary) // High-readability white over glass
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, Theme.Spacing.xs)
            }
            .padding(Theme.Spacing.lg)
            .glassCard(radius: Theme.Radius.lg)
        }
        .padding(.horizontal, Theme.Spacing.lg)
    }
    
    // Phase 2: Document Scanner View
    private var scannerView: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Text("Scan the front of your ID")
                .themeFont(.h2)
                .foregroundColor(.theme.textPrimary)
                .padding(.top, Theme.Spacing.lg)
            
            VStack(spacing: Theme.Spacing.xl) {
                // Glass scanning window
                ZStack {
                    // Dark viewfinder background
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.4))
                        .frame(height: 200)
                    
                    // Card template outline
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            currentPhase == .success ? Color.theme.success : Color.white.opacity(0.4),
                            style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [8, 6])
                        )
                        .frame(width: 260, height: 150)
                    
                    // Graphic of a card layout inside the guide
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.15))
                    
                    // Glowing laser line scanning up and down
                    if currentPhase == .scanning && !reduceMotion {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.theme.accentTeal.opacity(0), Color.theme.accentTeal, Color.theme.accentTeal.opacity(0)],
                                    startPoint: .top, endPoint: .bottom
                                )
                            )
                            .frame(width: 280, height: 4)
                            .shadow(color: Color.theme.accentTeal.opacity(0.8), radius: 8)
                            .offset(y: laserOffset)
                            .onAppear {
                                withAnimation(
                                    .easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true)
                                ) {
                                    laserOffset = 100
                                }
                            }
                    }
                    
                    // Scanner success overlay
                    if currentPhase == .success {
                        ZStack {
                            Color.black.opacity(0.5)
                            
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.theme.success)
                                .scaleEffect(scanProgress >= 1.0 ? 1.0 : 0.5)
                                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: scanProgress)
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .glassCard(radius: Theme.Radius.lg)
                
                // Scanning status indicator
                VStack(spacing: Theme.Spacing.xs) {
                    if currentPhase == .scanning {
                        ProgressView()
                            .tint(.theme.accentTeal)
                            .padding(.bottom, 2)
                        Text("Verifying document security...")
                            .themeFont(.caption)
                            .foregroundColor(.theme.accentTeal)
                    } else {
                        Text("Document verified successfully!")
                            .themeFont(.title)
                            .foregroundColor(.theme.success)
                    }
                }
                .animation(.easeInOut, value: currentPhase)
            }
            .padding(.horizontal, Theme.Spacing.lg)
        }
        .padding(.horizontal, Theme.Spacing.lg)
    }
    
    private var isValid: Bool {
        !data.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !data.lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !data.idNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func startScanning() {
        focusedField = nil
        
        withAnimation {
            currentPhase = .scanning
        }
        
        // Haptic start scan
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        // Simulate scan duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            // Haptic success scan
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            
            withAnimation {
                currentPhase = .success
                scanProgress = 1.0
            }
            
            // Proceed to next screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                data.signupRewardAmount += 100.0
                onNext()
            }
        }
    }
}

#Preview {
    OnboardingKYCView(data: .constant(OnboardingData()), onNext: {}, onBack: {})
}
