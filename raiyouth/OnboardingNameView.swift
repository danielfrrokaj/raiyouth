import SwiftUI

struct OnboardingNameView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case firstName, lastName
    }
    
    var isFormValid: Bool {
        !data.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !data.lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
                
                Image(systemName: "house.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.theme.accentPrimary)
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.xs)
            
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                Text("What's your name?")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.theme.textPrimary)
                    .padding(.top, Theme.Spacing.lg)

                Text("Enter your legal name exactly as it appears on your ID.")
                    .themeFont(.caption)
                    .foregroundColor(.theme.textSecondary)
                
                VStack(spacing: Theme.Spacing.lg) {
                    // First Name Field
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("", text: $data.firstName, prompt: Text("First name").foregroundColor(.white.opacity(0.3)))
                            .focused($focusedField, equals: .firstName)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .frame(height: 54)
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(Theme.Radius.md)
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.Radius.md)
                                    .stroke(focusedField == .firstName ? Color.theme.accentPrimary : Color.white.opacity(0.1), lineWidth: 1)
                            )
                        
                        Text("E.g., Daniel, not \"Dan\"")
                            .font(.system(size: 12))
                            .foregroundColor(.theme.textTertiary)
                            .padding(.leading, 4)
                    }
                    
                    // Last Name Field
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("", text: $data.lastName, prompt: Text("Last name").foregroundColor(.white.opacity(0.3)))
                            .focused($focusedField, equals: .lastName)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .frame(height: 54)
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(Theme.Radius.md)
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.Radius.md)
                                    .stroke(focusedField == .lastName ? Color.theme.accentPrimary : Color.white.opacity(0.1), lineWidth: 1)
                            )
                    }
                }
                .padding(.top, Theme.Spacing.md)
                
                if isFormValid {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.theme.accentPrimary)
                        Text("Name confirmed")
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
                Text("Continue")
            }
            .buttonStyle(PremiumButtonStyle(isEnabled: isFormValid))
            .disabled(!isFormValid)
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.xl)
        }
        .background(Color.theme.canvas.ignoresSafeArea())
        .onAppear {
            focusedField = .firstName
        }
    }
}

#Preview {
    OnboardingNameView(data: .constant(OnboardingData()), onNext: {}, onBack: {})
}
