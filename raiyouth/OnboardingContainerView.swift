//
//  OnboardingContainerView.swift
//  raiyouth
//

import SwiftUI

struct OnboardingContainerView: View {
    @State private var data = OnboardingData()
    @State private var currentStep = 1
    
    // Pulse animation state for the current step indicator
    @State private var pulseOpacity: Double = 0.6
    @State private var pulseScale: CGFloat = 1.0
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    
    let onOnboardingComplete: (OnboardingData) -> Void
    
    private let stepTitles = [
        "details",
        "otp",
        "dob",
        "email",
        "scan id",
        "selfie"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Simple Sticky Progress Bar
            progressHeader
                .padding(.top, Theme.Spacing.xl)
                .padding(.bottom, Theme.Spacing.sm)
                .background(Color.theme.canvas.ignoresSafeArea(edges: .top))
            // Onboarding Step Content with transitions
            ZStack {
                switch currentStep {
                case 1:
                    OnboardingWelcomeView(data: $data, onNext: {
                        navigateToStep(2)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 2:
                    OnboardingOTPView(data: $data, onNext: {
                        navigateToStep(3)
                    }, onBack: {
                        navigateToStep(1)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 3:
                    OnboardingDOBView(data: $data, onNext: {
                        navigateToStep(4)
                    }, onBack: {
                        navigateToStep(2)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 4:
                    OnboardingEmailView(data: $data, onNext: {
                        navigateToStep(5)
                    }, onBack: {
                        navigateToStep(3)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 5:
                    OnboardingKYCView(data: $data, onNext: {
                        navigateToStep(6)
                    }, onBack: {
                        navigateToStep(4)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 6:
                    OnboardingSelfieView(data: $data, onNext: {
                        navigateToStep(7)
                    }, onBack: {
                        navigateToStep(5)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 7:
                    OnboardingSuccessView(data: $data, onFinish: {
                        onOnboardingComplete(data)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                default:
                    EmptyView()
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: currentStep)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.theme.canvas.ignoresSafeArea())
        .onAppear {
            if !reduceMotion {
                withAnimation(
                    .easeInOut(duration: 1.0)
                    .repeatForever(autoreverses: true)
                ) {
                    pulseOpacity = 0.1
                    pulseScale = 1.6
                }
            }
        }
    }
    
    private func navigateToStep(_ step: Int) {
        // Haptic tap
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.prepare()
        impact.impactOccurred()
        
        withAnimation {
            currentStep = step
        }
    }
    
    // Simple Sticky Progress Bar
    private var progressHeader: some View {
        GeometryReader { geometry in
            let totalSteps = 6.0
            let percentage = Double(min(currentStep, 6)) / totalSteps
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 4)
                
                Rectangle()
                    .fill(Color.theme.accentPrimary)
                    .frame(width: geometry.size.width * CGFloat(percentage), height: 4)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: percentage)
            }
        }
        .frame(height: 4)
    }
}

#Preview {
    OnboardingContainerView(onOnboardingComplete: { _ in })
}
