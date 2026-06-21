import SwiftUI

struct OnboardingPasscodeView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    @State private var isConfirming = false
    @State private var passcodeText = ""
    @State private var confirmPasscodeText = ""
    @State private var showError = false
    
    var currentText: String {
        isConfirming ? confirmPasscodeText : passcodeText
    }
    
    var isPasscodeValid: Bool {
        currentText.count >= 6 && currentText.count <= 12
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                Button(action: {
                    if isConfirming {
                        withAnimation {
                            isConfirming = false
                            confirmPasscodeText = ""
                        }
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
            
            VStack(spacing: Theme.Spacing.xl) {
                VStack(spacing: Theme.Spacing.md) {
                    Text(isConfirming ? "Confirm your passcode" : "Create a passcode")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.theme.textPrimary)
                        .padding(.top, Theme.Spacing.xl)

                    if isConfirming {
                        Text(showError ? "Passcodes don't match. Please try again." : "Re-enter your passcode to confirm.")
                            .themeFont(.caption)
                            .foregroundColor(showError ? Color.theme.danger : .theme.textSecondary)
                    } else {
                        Text(showError ? "Passcode must be between 6 and 12 digits." : "This protects your account. Keep it somewhere safe.")
                            .themeFont(.caption)
                            .foregroundColor(showError ? Color.theme.danger : .theme.textSecondary)
                    }
                }
                
                Spacer()
                
                // Centered Dots (dynamic count on confirmation matching created passcode length)
                let totalDots = isConfirming ? passcodeText.count : 6
                HStack(spacing: 16) {
                    ForEach(0..<totalDots, id: \.self) { index in
                        Circle()
                            .fill(index < currentText.count ? Color.white : Color.white.opacity(0.18))
                            .frame(width: 14, height: 14)
                    }
                }
                .padding(.vertical, Theme.Spacing.xxl)
                
                Spacer()
                
                // Custom Numeric Keypad on Canvas
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        keypadButton("1")
                        keypadButton("2")
                        keypadButton("3")
                    }
                    HStack(spacing: 12) {
                        keypadButton("4")
                        keypadButton("5")
                        keypadButton("6")
                    }
                    HStack(spacing: 12) {
                        keypadButton("7")
                        keypadButton("8")
                        keypadButton("9")
                    }
                    HStack(spacing: 12) {
                        // Backspace Key
                        Button(action: deleteDigit) {
                            Image(systemName: "delete.left")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.white.opacity(0.06))
                                .cornerRadius(Theme.Radius.md)
                        }
                        
                        keypadButton("0")
                        
                        // Action Arrow Key
                        Button(action: submitPasscode) {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(isPasscodeValid ? Color.theme.textOnAccentYellow : .white.opacity(0.3))
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(isPasscodeValid ? Color.theme.accentPrimary : Color.white.opacity(0.06))
                                .cornerRadius(Theme.Radius.md)
                        }
                        .disabled(!isPasscodeValid)
                    }
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.bottom, Theme.Spacing.xl)
            }
        }
        .background(Color.theme.canvas.ignoresSafeArea())
    }
    
    private func keypadButton(_ digit: String) -> some View {
        Button(action: { addDigit(digit) }) {
            Text(digit)
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.white.opacity(0.06))
                .cornerRadius(Theme.Radius.md)
        }
    }
    
    private func addDigit(_ digit: String) {
        let text = isConfirming ? confirmPasscodeText : passcodeText
        guard text.count < 12 else { return }
        
        showError = false
        if isConfirming {
            confirmPasscodeText += digit
        } else {
            passcodeText += digit
        }
    }
    
    private func deleteDigit() {
        showError = false
        if isConfirming {
            if !confirmPasscodeText.isEmpty {
                confirmPasscodeText.removeLast()
            }
        } else {
            if !passcodeText.isEmpty {
                passcodeText.removeLast()
            }
        }
    }
    
    private func submitPasscode() {
        if !isConfirming {
            withAnimation {
                isConfirming = true
            }
        } else {
            // Confirm entries match
            if passcodeText == confirmPasscodeText {
                data.passcode = passcodeText
                onNext()
            } else {
                // Play mismatch warning feedback
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                showError = true
                confirmPasscodeText = ""
            }
        }
    }
}

#Preview {
    OnboardingPasscodeView(data: .constant(OnboardingData()), onNext: {}, onBack: {})
}
