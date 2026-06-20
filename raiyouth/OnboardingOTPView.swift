import SwiftUI

struct OnboardingOTPView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    @State private var pinString = ""
    @FocusState private var isFocused: Bool
    @State private var countdown = 25
    @State private var timerActive = true
    
    var isPinComplete: Bool {
        pinString.count == 6
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
                Text("Activate Signal Tower")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.theme.textPrimary)
                    .padding(.top, Theme.Spacing.lg)
                
                Text("Enter the 6-digit verification code sent to +355 \(data.phoneNumber) to activate your tower.")
                    .themeFont(.caption)
                    .foregroundColor(.theme.textSecondary)
                
                // Revolut split style pin fields: [ ][ ][ ] - [ ][ ][ ]
                HStack(spacing: 8) {
                    ForEach(0..<6, id: \.self) { index in
                        let isFilled = index < pinString.count
                        let isActive = index == pinString.count
                        
                        ZStack {
                            if !isFilled {
                                Rectangle()
                                    .fill(Color.white.opacity(0.06))
                            } else {
                                Rectangle()
                                    .fill(Color.white.opacity(0.1))
                            }
                            
                            if isFilled {
                                Text("•")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold))
                            } else {
                                Text("")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .cornerRadius(Theme.Radius.sm)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.sm)
                                .stroke(
                                    isActive ? Color.theme.accentPrimary : Color.white.opacity(0.1),
                                    lineWidth: isActive ? 1.5 : 1
                                )
                        )
                        .onTapGesture {
                            isFocused = true
                        }
                        
                        // Add visual split separator dash between index 2 and 3
                        if index == 2 {
                            Text("-")
                                .foregroundColor(.white.opacity(0.3))
                                .font(.system(size: 20, weight: .bold))
                                .padding(.horizontal, 4)
                        }
                    }
                }
                .background(
                    TextField("", text: $pinString)
                        .keyboardType(.numberPad)
                        .focused($isFocused)
                        .opacity(0.01)
                        .frame(width: 1, height: 1)
                        .onChange(of: pinString) { oldValue, newValue in
                            if newValue.count > 6 {
                                pinString = String(newValue.prefix(6))
                            }
                            
                            if pinString.count == 6 {
                                isFocused = false
                                // Delay slightly for visual effect then proceed
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    data.otpCode = pinString
                                    onNext()
                                }
                            }
                        }
                )
                .padding(.top, Theme.Spacing.lg)
                
                if isPinComplete {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.theme.accentPrimary)
                        Text("Signal Tower Activated")
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
                
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    if countdown > 0 {
                        Text("Resend code in 00:\(String(format: "%02d", countdown))")
                            .themeFont(.caption)
                            .foregroundColor(.theme.textTertiary)
                    } else {
                        Button(action: {
                            countdown = 25
                            timerActive = true
                            startTimer()
                        }) {
                            Text("Resend code")
                                .themeFont(.caption)
                                .foregroundColor(Color.theme.accentPrimary)
                        }
                    }
                }
                .padding(.top, Theme.Spacing.md)
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            Spacer()
        }
        .background(Color.theme.canvas.ignoresSafeArea())
        .onAppear {
            isFocused = true
            startTimer()
        }
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

#Preview {
    OnboardingOTPView(data: .constant(OnboardingData()), onNext: {}, onBack: {})
}
