//
//  OnboardingOTPView.swift
//  raiyouth
//

import SwiftUI

struct OnboardingOTPView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    @State private var activePinIndex: Int? = 0
    @State private var pin: [String] = Array(repeating: "", count: 6)
    @State private var countdown = 25
    @State private var timerActive = true
    
    var isPinComplete: Bool {
        pin.allSatisfy { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
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
                pose: isPinComplete ? .cheer : .idle,
                speechBubbleText: isPinComplete ?
                    "Phone verified! You're one step closer." :
                    "Check your messages! I sent you a code.",
                isHeroSize: false
            )
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.md)
            .padding(.bottom, Theme.Spacing.lg)
            
            VStack(alignment: .leading, spacing: Theme.Spacing.xl) {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("Enter the code we sent you")
                        .themeFont(.h1)
                        .foregroundColor(.theme.textPrimary)
                    
                    Text("We sent a 6-digit code to +383 \(data.phoneNumber)")
                        .themeFont(.caption)
                        .foregroundColor(.theme.textSecondary)
                }
                
                // PIN Boxes (Revolut-like minimal design)
                HStack(spacing: 12) {
                    ForEach(0..<6, id: \.self) { index in
                        ZStack {
                            if pin[index].isEmpty {
                                Text("•")
                                    .foregroundColor(.white.opacity(0.20))
                                    .font(.system(size: 20, weight: .bold))
                            } else {
                                Text(pin[index])
                                    .foregroundColor(.white)
                                    .font(.system(size: 22, weight: .bold))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.theme.surface3)
                        .cornerRadius(Theme.Radius.sm)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.sm)
                                .stroke(
                                    activePinIndex == index ? Color.theme.accentPrimary : Color.theme.glassBorder,
                                    lineWidth: activePinIndex == index ? 1.5 : 1
                                )
                        )
                        .onTapGesture {
                            activePinIndex = index
                        }
                    }
                }
                .background(
                    // Invisible TextField to receive inputs
                    PinReceiver(pin: $pin, activeIndex: $activePinIndex)
                        .opacity(0.01)
                )
                
                // Resend Countdown
                HStack {
                    Spacer()
                    if countdown > 0 {
                        Text("Resend code (00:\(String(format: "%02d", countdown)))")
                            .themeFont(.caption)
                            .foregroundColor(.theme.textTertiary)
                    } else {
                        Button(action: {
                            countdown = 25
                            timerActive = true
                        }) {
                            Text("Resend code")
                                .themeFont(.caption)
                                .foregroundColor(.theme.accentPrimary)
                        }
                    }
                    Spacer()
                }
                .padding(.top, Theme.Spacing.xs)
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .onAppear {
                activePinIndex = 0
                startTimer()
            }
            
            Spacer()
            
            // Sub-Reward badge
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .foregroundColor(.theme.accentPrimary)
                    .font(.system(size: 14, weight: .bold))
                Text("+50 RaiPoints")
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
                data.otpCode = pin.joined()
                data.signupRewardAmount += 50.0
                onNext()
            }) {
                Text("Continue")
            }
            .buttonStyle(PremiumButtonStyle(isEnabled: isPinComplete))
            .disabled(!isPinComplete)
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.lg)
        }
        .ambientGlows()
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdown > 0 {
                countdown -= 1
            } else {
                timer.invalidate()
                timerActive = false
            }
        }
    }
}

// Helper UIViewRepresentable to capture keyboard input cleanly for all boxes
struct PinReceiver: UIViewRepresentable {
    @Binding var pin: [String]
    @Binding var activeIndex: Int?
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: PinReceiver
        
        init(_ parent: PinReceiver) {
            self.parent = parent
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentString = textField.text ?? ""
            guard let stringRange = Range(range, in: currentString) else { return false }
            let updatedText = currentString.replacingCharacters(in: stringRange, with: string)
            
            // Process the input
            if string.isEmpty {
                // Backspace
                if let index = parent.activeIndex {
                    parent.pin[index] = ""
                    if index > 0 {
                        parent.activeIndex = index - 1
                    }
                }
            } else {
                // Character entry
                if let index = parent.activeIndex, index < 6 {
                    let char = String(string.prefix(1))
                    parent.pin[index] = char
                    if index < 5 {
                        parent.activeIndex = index + 1
                    }
                }
            }
            return false
        }
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.delegate = context.coordinator
        textField.tintColor = .clear
        textField.textColor = .clear
        
        // Auto-focus helper
        DispatchQueue.main.async {
            textField.becomeFirstResponder()
        }
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        // Keeps focus synced
        if activeIndex != nil && !uiView.isFirstResponder {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

#Preview {
    OnboardingOTPView(data: .constant(OnboardingData()), onNext: {}, onBack: {})
}
