import SwiftUI

struct OnboardingWelcomeView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    @FocusState private var isFocused: Bool
    
    var isPhoneValid: Bool {
        let clean = data.phoneNumber.filter { $0.isNumber }
        return clean.count >= 6 && clean.count <= 12
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with Back Button
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
                Text("What's your phone number?")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.theme.textPrimary)
                    .padding(.top, Theme.Spacing.lg)

                Text("We'll send you a short verification code to confirm it's really you.")
                    .themeFont(.caption)
                    .foregroundColor(.theme.textSecondary)
                
                HStack(spacing: Theme.Spacing.md) {
                    // Country Code selector box
                    HStack(spacing: 6) {
                        Text("🇦🇱")
                            .font(.system(size: 22))
                        Text("+355")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 14)
                    .frame(height: 54)
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(Theme.Radius.md)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.md)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    
                    // Phone textfield
                    TextField("", text: $data.phoneNumber, prompt: Text("Mobile number").foregroundColor(.white.opacity(0.3)))
                        .keyboardType(.numberPad)
                        .focused($isFocused)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .frame(height: 54)
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(Theme.Radius.md)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.md)
                                .stroke(isFocused ? Color.theme.accentPrimary : Color.white.opacity(0.1), lineWidth: 1)
                        )
                        .tint(Color.theme.accentPrimary)
                }
                .padding(.top, Theme.Spacing.md)
                
                if isPhoneValid {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.theme.accentPrimary)
                        Text("Looks good")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.theme.accentPrimary.opacity(0.15))
                    .cornerRadius(10)
                    .transition(.scale.combined(with: .opacity))
                    .padding(.top, 8)
                }
                
                Button(action: {
                    // Navigate to Login/Already have account handler
                }) {
                    Text("Already have an account? Log in")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.theme.accentTeal)
                }
                .padding(.top, Theme.Spacing.xs)
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            Spacer()
            
            // Continue/Sign up button
            Button(action: onNext) {
                Text("Send code")
            }
            .buttonStyle(PremiumButtonStyle(isEnabled: isPhoneValid))
            .disabled(!isPhoneValid)
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.xl)
        }
        .background(Color.theme.canvas.ignoresSafeArea())
        .onAppear {
            isFocused = true
        }
    }
}

#Preview {
    OnboardingWelcomeView(data: .constant(OnboardingData()), onNext: {}, onBack: {})
}
