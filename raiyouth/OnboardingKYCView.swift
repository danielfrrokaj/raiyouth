import SwiftUI

// High-tech viewport corner brackets for camera viewfinder
struct ViewfinderCornerBrackets: View {
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            let w = geometry.size.width
            let h = geometry.size.height
            let len: CGFloat = 20
            let thick: CGFloat = 3
            
            ZStack {
                // Top Left
                Path { path in
                    path.move(to: CGPoint(x: 0, y: len))
                    path.addLine(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: len, y: 0))
                }
                .stroke(color, lineWidth: thick)
                
                // Top Right
                Path { path in
                    path.move(to: CGPoint(x: w - len, y: 0))
                    path.addLine(to: CGPoint(x: w, y: 0))
                    path.addLine(to: CGPoint(x: w, y: len))
                }
                .stroke(color, lineWidth: thick)
                
                // Bottom Left
                Path { path in
                    path.move(to: CGPoint(x: 0, y: h - len))
                    path.addLine(to: CGPoint(x: 0, y: h))
                    path.addLine(to: CGPoint(x: len, y: h))
                }
                .stroke(color, lineWidth: thick)
                
                // Bottom Right
                Path { path in
                    path.move(to: CGPoint(x: w - len, y: h))
                    path.addLine(to: CGPoint(x: w, y: h))
                    path.addLine(to: CGPoint(x: w, y: h - len))
                }
                .stroke(color, lineWidth: thick)
            }
        }
    }
}

struct OnboardingKYCView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    enum KYCPhase {
        case inputs
        case scanning
        case success
    }
    
    @State private var currentPhase: KYCPhase = .inputs
    @State private var laserOffset: CGFloat = -75
    @State private var scanProgress: Double = 0.0
    
    @FocusState private var focusedField: Field?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    
    enum Field {
        case id
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    if currentPhase == .scanning {
                        withAnimation { currentPhase = .inputs }
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
            .padding(.top, Theme.Spacing.sm)
            
            // Custom guide with rai-security image
            HStack(alignment: .top, spacing: Theme.Spacing.md) {
                Image("rai-security")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96, height: 96)
                
                Text(currentPhase == .scanning ?
                    "Hold your document steady in the frame." :
                    "We need to confirm who you are to open the Trust Gate safely.")
                    .themeFont(.caption)
                    .foregroundColor(.theme.textPrimary)
                    .padding(.horizontal, Theme.Spacing.lg)
                    .padding(.vertical, Theme.Spacing.md)
                    .background(
                        SpeechBubbleShape()
                            .fill(reduceTransparency ? Color.theme.surface3 : Color.theme.glassFill)
                    )
                    .overlay(
                        SpeechBubbleShape()
                            .stroke(Color.theme.glassBorder, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                    .padding(.top, Theme.Spacing.xs)
                
                Spacer()
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.md)
            
            // Main Content Area
            ZStack {
                if currentPhase == .inputs {
                    inputsView
                        .transition(reduceMotion ? .opacity : .move(edge: .leading))
                } else {
                    scannerView
                        .transition(reduceMotion ? .opacity : .move(edge: .trailing))
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: currentPhase)
            
            Spacer()
            
            // Primary button (SOLID yellow) - hidden during scanning
            if currentPhase == .inputs {
                Button(action: startScanning) {
                    Text("Verify identity")
                }
                .buttonStyle(PremiumButtonStyle(isEnabled: isValid))
                .disabled(!isValid)
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.bottom, Theme.Spacing.lg)
            }
        }
        .background(Color.theme.canvas.ignoresSafeArea())
        .onAppear {
            if currentPhase == .inputs {
                focusedField = .id // Focus document number first since name is read-only
            }
        }
    }
    
    // Phase 1: Inputs View
    private var inputsView: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Open the Trust Gate")
                .themeFont(.h2)
                .foregroundColor(.theme.textPrimary)
                .padding(.top, Theme.Spacing.lg)
            
            VStack(spacing: Theme.Spacing.lg) {
                // Name Input
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("Full name")
                        .themeFont(.caption)
                        .foregroundColor(.theme.textSecondary)
                    
                    HStack {
                        Text(data.fullName)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 54)
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(Theme.Radius.md)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.md)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                }
                
                // Date of Birth & Phone
                HStack(spacing: Theme.Spacing.md) {
                    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                        Text("Date of birth")
                            .themeFont(.caption)
                            .foregroundColor(.theme.textSecondary)
                        
                        HStack {
                            Text(data.dateOfBirth)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 54)
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(Theme.Radius.md)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.md)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                        Text("Phone number")
                            .themeFont(.caption)
                            .foregroundColor(.theme.textSecondary)
                        
                        HStack {
                            Text("+355 \(data.phoneNumber)")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 54)
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(Theme.Radius.md)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.md)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                    }
                }
                
                // Email
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("Email address")
                        .themeFont(.caption)
                        .foregroundColor(.theme.textSecondary)
                    
                    HStack {
                        Text(data.email)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 54)
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(Theme.Radius.md)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.md)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                }
                
                // Document Number Input
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("Document number (ID card / passport)")
                        .themeFont(.caption)
                        .foregroundColor(.theme.textSecondary)
                    
                    TextField("", text: $data.idNumber, prompt: Text("E.g. A12345678B").foregroundColor(.white.opacity(0.3)))
                        .focused($focusedField, equals: .id)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .frame(height: 54)
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(Theme.Radius.md)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.md)
                                .stroke(focusedField == .id ? Color.theme.accentPrimary : Color.white.opacity(0.12), lineWidth: 1)
                        )
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                }
            }
        }
        .padding(.horizontal, Theme.Spacing.lg)
    }
    
    // Phase 2: Document Scanner View
    private var scannerView: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Text("Scan the front of your ID")
                .themeFont(.h2)
                .foregroundColor(.theme.textPrimary)
                .padding(.top, Theme.Spacing.lg)
            
            VStack(spacing: Theme.Spacing.xl) {
                // Glass scanning window
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.45))
                        .frame(height: 200)
                    
                    ViewfinderCornerBrackets(color: currentPhase == .success ? Color.theme.success : Color.theme.accentTeal)
                        .frame(width: 260, height: 150)
                    
                    Image(systemName: "person.text.rectangle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.white.opacity(0.12))
                    
                    if currentPhase == .scanning && !reduceMotion {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.theme.accentTeal.opacity(0), Color.theme.accentTeal, Color.theme.accentTeal.opacity(0)],
                                    startPoint: .top, endPoint: .bottom
                                )
                            )
                            .frame(width: 270, height: 3)
                            .shadow(color: Color.theme.accentTeal.opacity(0.8), radius: 6)
                            .offset(y: laserOffset)
                            .onAppear {
                                withAnimation(
                                    .easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true)
                                ) {
                                    laserOffset = 75
                                }
                            }
                    }
                    
                    if currentPhase == .success {
                        ZStack {
                            Color.black.opacity(0.5)
                            
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.theme.success)
                                .scaleEffect(scanProgress >= 1.0 ? 1.0 : 0.5)
                                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: scanProgress)
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(reduceTransparency ? Color.theme.surface2 : Color.white.opacity(0.04))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
                
                VStack(spacing: Theme.Spacing.xs) {
                    if currentPhase == .scanning {
                        ProgressView()
                            .tint(.theme.accentTeal)
                            .padding(.bottom, 2)
                        Text("Verifying document security...")
                            .themeFont(.caption)
                            .foregroundColor(.theme.accentTeal)
                    } else {
                        Text("Document verified successfully!")
                            .themeFont(.title)
                            .foregroundColor(.theme.success)
                    }
                }
                .animation(.easeInOut, value: currentPhase)
            }
            .padding(.horizontal, Theme.Spacing.lg)
        }
        .padding(.horizontal, Theme.Spacing.lg)
    }
    
    private var isValid: Bool {
        !data.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !data.lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !data.idNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func startScanning() {
        focusedField = nil
        
        withAnimation {
            currentPhase = .scanning
        }
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            
            withAnimation {
                currentPhase = .success
                scanProgress = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                onNext()
            }
        }
    }
}

#Preview {
    OnboardingKYCView(data: .constant(OnboardingData()), onNext: {}, onBack: {})
}
