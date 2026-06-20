import SwiftUI

struct OnboardingAddressView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    @FocusState private var focusedField: AddressField?
    
    enum AddressField {
        case zipCode, streetName, floorUnit
    }
    
    var isAddressValid: Bool {
        !data.zipCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !data.streetName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
                Text("Set Home Base")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.theme.textPrimary)
                    .padding(.top, Theme.Spacing.lg)
                
                Text("Enter your residential address to anchor your island home in the real world.")
                    .themeFont(.caption)
                    .foregroundColor(.theme.textSecondary)
                    .lineSpacing(3)
                
                VStack(spacing: Theme.Spacing.lg) {
                    // ZIP Code field
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("", text: $data.zipCode, prompt: Text("Zip code").foregroundColor(.white.opacity(0.3)))
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .zipCode)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .frame(height: 54)
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(Theme.Radius.md)
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.Radius.md)
                                    .stroke(focusedField == .zipCode ? Color.theme.accentPrimary : Color.white.opacity(0.1), lineWidth: 1)
                            )
                        
                        Text("E.g.: 1001")
                            .font(.system(size: 12))
                            .foregroundColor(.theme.textTertiary)
                            .padding(.leading, 4)
                    }
                    
                    // Street name field
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            TextField("", text: $data.streetName, prompt: Text("Street name, building").foregroundColor(.white.opacity(0.3)))
                                .focused($focusedField, equals: .streetName)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(data.streetName.count)/50")
                                .font(.system(size: 11))
                                .foregroundColor(.theme.textTertiary)
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 54)
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(Theme.Radius.md)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.md)
                                .stroke(focusedField == .streetName ? Color.theme.accentPrimary : Color.white.opacity(0.1), lineWidth: 1)
                        )
                        
                        Text("E.g.: Rruga Ismail Qemali, Nd. 4")
                            .font(.system(size: 12))
                            .foregroundColor(.theme.textTertiary)
                            .padding(.leading, 4)
                    }
                    
                    // Floor, unit number field
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            TextField("", text: $data.floorUnit, prompt: Text("Floor, unit number").foregroundColor(.white.opacity(0.3)))
                                .focused($focusedField, equals: .floorUnit)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(data.floorUnit.count)/50")
                                .font(.system(size: 11))
                                .foregroundColor(.theme.textTertiary)
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 54)
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(Theme.Radius.md)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.md)
                                .stroke(focusedField == .floorUnit ? Color.theme.accentPrimary : Color.white.opacity(0.1), lineWidth: 1)
                        )
                        
                        Text("E.g.: Floor 3, Apt. 12")
                            .font(.system(size: 12))
                            .foregroundColor(.theme.textTertiary)
                            .padding(.leading, 4)
                    }
                }
                .padding(.top, Theme.Spacing.md)
                
                if isAddressValid {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.theme.accentPrimary)
                        Text("Home Base Set")
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
            
            // Continue Button
            Button(action: onNext) {
                Text("Set home base")
            }
            .buttonStyle(PremiumButtonStyle(isEnabled: isAddressValid))
            .disabled(!isAddressValid)
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.xl)
        }
        .background(Color.theme.canvas.ignoresSafeArea())
        .onAppear {
            focusedField = .zipCode
        }
    }
}

#Preview {
    OnboardingAddressView(data: .constant(OnboardingData()), onNext: {}, onBack: {})
}
