import SwiftUI

struct OnboardingEmailView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    @FocusState private var isFocused: Bool
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: data.email)
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
            
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                Text("Add Backup Beacon")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.theme.textPrimary)
                    .padding(.top, Theme.Spacing.lg)
                
                Text("Enter your email address. This acts as a secure backup beacon to recover your island if needed.")
                    .themeFont(.caption)
                    .foregroundColor(.theme.textSecondary)
                
                // Email input field
                TextField("", text: $data.email, prompt: Text("Your email").foregroundColor(.white.opacity(0.3)))
                    .keyboardType(.emailAddress)
                    .focused($isFocused)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
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
                    .padding(.top, Theme.Spacing.md)
                
                if isValidEmail {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.theme.accentPrimary)
                        Text("Backup Beacon Added")
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
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            Spacer()
            
            // Continue Button (SOLID yellow)
            Button(action: onNext) {
                Text("Add beacon")
            }
            .buttonStyle(PremiumButtonStyle(isEnabled: isValidEmail))
            .disabled(!isValidEmail)
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
    OnboardingEmailView(data: .constant(OnboardingData()), onNext: {}, onBack: {})
}
