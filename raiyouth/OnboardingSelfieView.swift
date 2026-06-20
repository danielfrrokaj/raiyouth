//
//  OnboardingSelfieView.swift
//  raiyouth
//

import SwiftUI

struct OnboardingSelfieView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    enum SelfiePhase {
        case preview
        case capturing
        case success
    }
    
    @State private var phase: SelfiePhase = .preview
    @State private var scanProgress = 0.0
    @State private var pulseScale: CGFloat = 1.0
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                Button(action: {
                    if phase == .capturing {
                        phase = .preview
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
            .padding(.top, Theme.Spacing.xs)
            
            // Zog guide character reaction
            ZogGuideView(
                pose: phase == .success ? .cheer : .idle,
                speechBubbleText: phase == .success ?
                    "Perfect! Identity confirmed." :
                    "Frame your face. Let's make sure it's you!",
                isHeroSize: false
            )
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.md)
            .padding(.bottom, Theme.Spacing.lg)
            
            VStack(spacing: Theme.Spacing.xl) {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    HStack {
                        Text("Take a selfie")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.theme.textPrimary)
                        Spacer()
                    }
                    
                    Text("We'll use this to verify it's really you.")
                        .themeFont(.caption)
                        .foregroundColor(.theme.textSecondary)
                }
                .padding(.horizontal, Theme.Spacing.lg)
                
                // Circular viewfinder
                ZStack {
                    // Outer breathing pulsing indicator ring
                    Circle()
                        .stroke(
                            phase == .success ? Color.theme.success.opacity(0.18) : Color.theme.accentTeal.opacity(0.12),
                            lineWidth: 8
                        )
                        .frame(width: 220, height: 220)
                        .scaleEffect(phase == .success ? 1.0 : pulseScale)
                        .onAppear {
                            if !reduceMotion && phase != .success {
                                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                                    pulseScale = 1.08
                                }
                            }
                        }
                    
                    // Progress indicator ring
                    Circle()
                        .stroke(Color.white.opacity(0.12), lineWidth: 4)
                        .frame(width: 220, height: 220)
                    
                    if phase == .capturing {
                        Circle()
                            .trim(from: 0.0, to: CGFloat(scanProgress))
                            .stroke(Color.theme.accentTeal, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .frame(width: 220, height: 220)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 2.0), value: scanProgress)
                    } else if phase == .success {
                        Circle()
                            .stroke(Color.theme.success, lineWidth: 4)
                            .frame(width: 220, height: 220)
                    }
                    
                    // Main face viewfinder mask
                    ZStack {
                        // User face placeholder
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                            .font(.system(size: 80))
                            .foregroundColor(phase == .success ? .theme.success.opacity(0.8) : .white.opacity(0.15))
                        
                        if phase == .success {
                            ZStack {
                                Color.black.opacity(0.3)
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.theme.success)
                            }
                        }
                    }
                    .frame(width: 200, height: 200)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .fill(reduceTransparency ? Color.theme.surface3 : Color.white.opacity(0.04))
                    )
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.1), lineWidth: 1))
                }
                .padding(.vertical, Theme.Spacing.md)
            }
            
            Spacer()
            
            // Capture Button (Revolut-like camera shutter)
            if phase == .preview {
                Button(action: takePhoto) {
                    ZStack {
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                            .frame(width: 68, height: 68)
                        
                        Circle()
                            .fill(Color.white)
                            .frame(width: 56, height: 56)
                    }
                }
                .padding(.bottom, Theme.Spacing.lg)
            } else if phase == .capturing {
                ProgressView()
                    .tint(.theme.accentTeal)
                    .scaleEffect(1.2)
                    .padding(.bottom, Theme.Spacing.lg + 20)
            } else {
                EmptyView()
            }
        }
        .background(Color.theme.canvas.ignoresSafeArea())
        .ambientGlows()
    }
    
    private func takePhoto() {
        withAnimation {
            phase = .capturing
            scanProgress = 1.0
        }
        
        // Haptic shutter click
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        
        // Simulating facial recognition verification
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Haptic success
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            
            withAnimation {
                phase = .success
            }
            
            // Proceed to final success screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                onNext()
            }
        }
    }
}

#Preview {
    OnboardingSelfieView(data: .constant(OnboardingData()), onNext: {}, onBack: {})
}
