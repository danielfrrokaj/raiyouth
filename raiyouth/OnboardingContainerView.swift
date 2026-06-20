import SwiftUI
import AudioToolbox // Imported for premium unlock sound

struct OnboardingContainerView: View {
    @State private var data = OnboardingData()
    @State private var currentStep = 1
    
    @State private var unlockImage: String? = nil
    @State private var unlockTitle: String = ""
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    
    let onOnboardingComplete: (OnboardingData) -> Void
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
            // Money Island Visual Progress Header (only shown after slides landing and story views)
            if currentStep > 2 {
                progressHeader
                    .padding(.top, Theme.Spacing.md)
                    .padding(.bottom, Theme.Spacing.sm)
                    .background(Color.theme.canvas.ignoresSafeArea(edges: .top))
            }
            
            // Onboarding Step Content with transitions
            ZStack {
                switch currentStep {
                case 1:
                    OnboardingSlidesView(onSignUp: {
                        navigateToStep(2)
                    }, onLogIn: {
                        navigateToStep(2)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
                // Storytelling & Rai Introduction
                case 2:
                    OnboardingStoryView(onNext: {
                        navigateToStep(3)
                    }, onBack: {
                        navigateToStep(1)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
                // Step 1: Meet Your Money Guide (Rai)
                case 3:
                    OnboardingGuideIntroView(data: $data, onNext: {
                        navigateToStep(4)
                    }, onBack: {
                        navigateToStep(2)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
                // Step 2: Signal Tower (2a. Phone, 2b. OTP, 2c. Email, 2d. Notifications)
                case 4:
                    OnboardingWelcomeView(data: $data, onNext: {
                        navigateToStep(5)
                    }, onBack: {
                        navigateToStep(3)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 5:
                    OnboardingOTPView(data: $data, onNext: {
                        navigateToStep(6)
                    }, onBack: {
                        navigateToStep(4)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 6:
                    OnboardingEmailView(data: $data, onNext: {
                        navigateToStep(7)
                    }, onBack: {
                        navigateToStep(5)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 7:
                    OnboardingNotificationsView(onNext: {
                        navigateToStep(8)
                    }, onBack: {
                        navigateToStep(6)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
                // Step 3: Profile House (3a. Name, 3b. DOB)
                case 8:
                    OnboardingNameView(data: $data, onNext: {
                        navigateToStep(9)
                    }, onBack: {
                        navigateToStep(7)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 9:
                    OnboardingDOBView(data: $data, onNext: {
                        navigateToStep(10)
                    }, onBack: {
                        navigateToStep(8)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
                // Step 4: Trust Gate (4a. Country, 4b. Citizenship, 4c. KYC Choice, 4d. Doc Picker, 4e. Terms, 4f. ID Scan, 4g. Selfie)
                case 10:
                    OnboardingCountryView(data: $data, onNext: {
                        navigateToStep(11)
                    }, onBack: {
                        navigateToStep(9)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 11:
                    OnboardingCitizenshipView(data: $data, onNext: {
                        navigateToStep(12)
                    }, onBack: {
                        navigateToStep(10)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 12:
                    OnboardingKYCOptionsView(data: $data, onSelectMethod: { method in
                        data.verificationMethod = method
                        navigateToStep(13)
                    }, onBack: {
                        navigateToStep(11)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 13:
                    OnboardingDocPickerView(data: $data, onNext: {
                        navigateToStep(14)
                    }, onBack: {
                        navigateToStep(12)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 14:
                    OnboardingTermsView(onAccept: {
                        navigateToStep(15)
                    }, onBack: {
                        navigateToStep(13)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 15:
                    OnboardingKYCView(data: $data, onNext: {
                        navigateToStep(16)
                    }, onBack: {
                        navigateToStep(14)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 16:
                    OnboardingSelfieView(data: $data, onNext: {
                        navigateToStep(17)
                    }, onBack: {
                        navigateToStep(15)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
                // Step 5: Home Base
                case 17:
                    OnboardingAddressView(data: $data, onNext: {
                        navigateToStep(18)
                    }, onBack: {
                        navigateToStep(16)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
                // Step 6: Vault Lock
                case 18:
                    OnboardingPasscodeView(data: $data, onNext: {
                        navigateToStep(19)
                    }, onBack: {
                        navigateToStep(17)
                    })
                    .transition(reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
                // Step 7: Island Complete
                case 19:
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
            
            // Full Screen Unlock Overlay
            if let imgName = unlockImage {
                IslandUnlockOverlay(imageName: imgName, stageName: unlockTitle) {
                    withAnimation(.easeOut(duration: 0.25)) {
                        unlockImage = nil
                    }
                }
                .transition(.opacity)
                .zIndex(100) // Render on top of everything
            }
        }
    }
    
    private func getIslandStageDetails(for step: Int) -> (image: String, title: String)? {
        switch step {
        case 3: return ("island_base", "Money Island")
        case 4, 5, 6, 7: return ("island_guide", "Guide Unlocked")
        case 8, 9: return ("island_tower", "Signal Tower Built")
        case 10, 11, 12, 13, 14, 15, 16: return ("island_house", "Profile House Built")
        case 17, 18: return ("island_gate", "Trust Gate Opened")
        case 19: return ("island_pin", "Vault Locked")
        default: return nil
        }
    }

    private func navigateToStep(_ step: Int) {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.prepare()
        impact.impactOccurred()
        
        let oldStep = currentStep
        let newStep = step
        
        withAnimation {
            currentStep = step
        }
        
        // Detect island completion / building unlock progression (only when moving forward)
        if newStep > oldStep {
            if let oldDetails = getIslandStageDetails(for: oldStep),
               let newDetails = getIslandStageDetails(for: newStep) {
                if oldDetails.image != newDetails.image {
                    // Trigger the full-screen unlock overlay
                    unlockImage = newDetails.image
                    unlockTitle = newDetails.title
                }
            }
        }
    }
    
    // Money Island Visual Progress Header + Micro-progress line
    private var progressHeader: some View {
        VStack(spacing: 8) {
            MoneyIslandProgressView(currentStep: currentStep)
            
            GeometryReader { geometry in
                let totalSteps = 16.0
                let percentage = Double(min(currentStep - 3, 16)) / totalSteps
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 2)
                    
                    Rectangle()
                        .fill(Color.theme.accentPrimary)
                        .frame(width: geometry.size.width * CGFloat(percentage), height: 2)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: percentage)
                }
            }
            .frame(height: 2)
            .padding(.horizontal, Theme.Spacing.lg)
        }
    }
}

#Preview {
    OnboardingContainerView(onOnboardingComplete: { _ in })
}

// Full screen unlock reward moment overlay
struct IslandUnlockOverlay: View {
    let imageName: String
    let stageName: String
    let onDismiss: () -> Void
    
    @State private var animateGlow = false
    @State private var animateScale = false
    @State private var animateText = false
    
    var body: some View {
        ZStack {
            // Dark background matching canvas
            Color.theme.canvas.ignoresSafeArea()
                .opacity(0.92)
            
            // Premium golden radial background glow
            RadialGradient(
                colors: [
                    Color.theme.accentPrimary.opacity(0.20),
                    Color.theme.accentPrimaryDeep.opacity(0.05),
                    Color.clear
                ],
                center: .center,
                startRadius: 10,
                endRadius: 360
            )
            .scaleEffect(animateGlow ? 1.6 : 0.8)
            .opacity(animateGlow ? 1.0 : 0.0)
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Big Island Image with Drop and Spring Scale
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 240)
                    .scaleEffect(animateScale ? 1.0 : 0.5)
                    .offset(y: animateScale ? 0 : -80) // nice drop effect
                    .rotationEffect(.degrees(animateScale ? 0 : -8))
                    .shadow(color: Color.theme.accentPrimary.opacity(0.35), radius: animateScale ? 40 : 0, x: 0, y: 15)
                
                // Unlock Details
                VStack(spacing: 10) {
                    Text("Unlocked")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color.theme.accentPrimary)
                        .textCase(.uppercase)
                        .tracking(3)
                    
                    Text(stageName.sentenceCased)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.Spacing.xl)
                }
                .opacity(animateText ? 1.0 : 0.0)
                .offset(y: animateText ? 0 : 20)
                
                Spacer()
            }
        }
        .onAppear {
            // Trigger premium success chime system sound (1033 is a clean double-tone notification sound)
            AudioServicesPlaySystemSound(1033)
            
            withAnimation(.spring(response: 0.65, dampingFraction: 0.65)) {
                animateScale = true
            }
            withAnimation(.easeInOut(duration: 0.9)) {
                animateGlow = true
            }
            withAnimation(.easeOut(duration: 0.45).delay(0.25)) {
                animateText = true
            }
            
            // Auto-dismiss after 2.0s
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                onDismiss()
            }
        }
    }
}
