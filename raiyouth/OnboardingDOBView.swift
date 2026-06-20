import SwiftUI

struct OnboardingDOBView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    @State private var day = ""
    @State private var month = ""
    @State private var year = ""
    
    @FocusState private var focusedField: DOBField?
    
    enum DOBField {
        case day, month, year
    }
    
    var isDobComplete: Bool {
        day.count == 2 && month.count == 2 && year.count == 4
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
                
                Image(systemName: "calendar")
                    .font(.system(size: 22))
                    .foregroundColor(.theme.accentPrimary)
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.xs)
            
            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                Text("Date of birth")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.theme.textPrimary)
                    .padding(.top, Theme.Spacing.lg)
                
                Text("We need your birth date to set up the right account type for you.")
                    .themeFont(.caption)
                    .foregroundColor(.theme.textSecondary)
                
                HStack(spacing: 12) {
                    // Month Input Box
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Month")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.theme.textSecondary)
                        
                        TextField("", text: $month, prompt: Text("MM").foregroundColor(.white.opacity(0.3)))
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .month)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .onChange(of: month) { _, newValue in
                                let clean = newValue.filter { $0.isNumber }
                                month = String(clean.prefix(2))
                                if month.count == 2 {
                                    focusedField = .day
                                }
                            }
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 58)
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(Theme.Radius.md)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.md)
                            .stroke(focusedField == .month ? Color.theme.accentPrimary : Color.white.opacity(0.1), lineWidth: 1)
                    )
                    
                    // Day Input Box
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Day")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.theme.textSecondary)
                        
                        TextField("", text: $day, prompt: Text("DD").foregroundColor(.white.opacity(0.3)))
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .day)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .onChange(of: day) { _, newValue in
                                let clean = newValue.filter { $0.isNumber }
                                day = String(clean.prefix(2))
                                if day.count == 2 {
                                    focusedField = .year
                                }
                            }
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 58)
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(Theme.Radius.md)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.md)
                            .stroke(focusedField == .day ? Color.theme.accentPrimary : Color.white.opacity(0.1), lineWidth: 1)
                    )
                    
                    // Year Input Box
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Year")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.theme.textSecondary)
                        
                        TextField("", text: $year, prompt: Text("YYYY").foregroundColor(.white.opacity(0.3)))
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .year)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .onChange(of: year) { _, newValue in
                                let clean = newValue.filter { $0.isNumber }
                                year = String(clean.prefix(4))
                            }
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 58)
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(Theme.Radius.md)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.md)
                            .stroke(focusedField == .year ? Color.theme.accentPrimary : Color.white.opacity(0.1), lineWidth: 1)
                    )
                }
                .padding(.top, Theme.Spacing.md)
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            Spacer()
            
            // Continue Button (SOLID yellow)
            Button(action: {
                data.dateOfBirth = "\(day)/\(month)/\(year)"
                onNext()
            }) {
                Text("Continue")
            }
            .buttonStyle(PremiumButtonStyle(isEnabled: isDobComplete))
            .disabled(!isDobComplete)
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.xl)
        }
        .background(Color.theme.canvas.ignoresSafeArea())
        .onAppear {
            focusedField = .month
            if !data.dateOfBirth.isEmpty {
                let parts = data.dateOfBirth.split(separator: "/")
                if parts.count == 3 {
                    day = String(parts[0])
                    month = String(parts[1])
                    year = String(parts[2])
                }
            }
        }
    }
}

#Preview {
    OnboardingDOBView(data: .constant(OnboardingData()), onNext: {}, onBack: {})
}
