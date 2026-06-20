import SwiftUI

struct OnboardingCardCustomizationView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    // Drag state for the 3D tilt effect
    @State private var dragOffset: CGSize = .zero
    @FocusState private var isAliasFocused: Bool
    
    // Card styles kept for ContentView compile compatibility
    enum CardColor: String, CaseIterable {
        case yellow
        case gray
        case teal
        
        var gradient: LinearGradient {
            switch self {
            case .yellow:
                return LinearGradient(
                    colors: [Color.theme.accentPrimary, Color.theme.accentPrimaryDeep],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
            case .gray:
                return LinearGradient(
                    colors: [Color.theme.surface2, Color.theme.surface1],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
            case .teal:
                return LinearGradient(
                    colors: [Color.theme.accentTeal, Color(hex: "1D555F")],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
            }
        }
        
        var textColor: Color {
            switch self {
            case .yellow:
                return Color.theme.textOnAccentYellow
            case .gray, .teal:
                return Color.theme.textPrimary
            }
        }
        
        var secondaryTextColor: Color {
            switch self {
            case .yellow:
                return Color.theme.textOnAccentYellow.opacity(0.6)
            case .gray, .teal:
                return Color.theme.textSecondary
            }
        }
    }
    
    var isFormValid: Bool {
        !data.aliasName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
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
            .padding(.top, Theme.Spacing.sm)
            
            // Inline guide
            ZogGuideView(
                pose: .idle,
                speechBubbleText: "Let's forge your debit card. Type the alias you'd like printed on your card to begin.",
                isHeroSize: false
            )
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.md)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: Theme.Spacing.lg) {
                    // Fixed Brand Yellow card preview (no swatches)
                    VStack(spacing: Theme.Spacing.xl) {
                        // Card View with 3D Tilt Effect
                        VStack(alignment: .leading) {
                            HStack {
                                Spacer()
                                Image(systemName: "wave.3.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .rotationEffect(.degrees(-90))
                            }
                            .foregroundColor(Color.theme.textOnAccentYellow)
                            
                            Spacer()
                            
                            // Chip graphic
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "F2D472"), Color(hex: "C5A03D")],
                                        startPoint: .topLeading, endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 40, height: 30)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.black.opacity(0.1), lineWidth: 1)
                                )
                                .padding(.bottom, Theme.Spacing.md)
                            
                            // Card numbers
                            Text("4218  9012  5542  \(String(format: "%04d", Calendar.current.component(.year, from: Date())))")
                                .font(.system(size: 19, weight: .medium, design: .monospaced))
                                .tracking(-0.5)
                                .foregroundColor(Color.theme.textOnAccentYellow)
                                .padding(.bottom, Theme.Spacing.xs)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Card holder")
                                        .themeFont(.micro)
                                        .foregroundColor(Color.theme.textOnAccentYellow.opacity(0.6))
                                    Text(data.aliasName.isEmpty ? "Your alias" : data.aliasName.sentenceCased)
                                        .themeFont(.title)
                                        .foregroundColor(Color.theme.textOnAccentYellow)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("Expires")
                                        .themeFont(.micro)
                                        .foregroundColor(Color.theme.textOnAccentYellow.opacity(0.6))
                                    Text("06/31")
                                        .themeFont(.title)
                                        .foregroundColor(Color.theme.textOnAccentYellow)
                                }
                            }
                        }
                        .padding(Theme.Spacing.xxl)
                        .frame(width: 320, height: 200)
                        .background(
                            LinearGradient(
                                colors: [Color.theme.accentPrimary, Color.theme.accentPrimaryDeep],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.4), radius: 20, x: 0, y: 10)
                        .rotation3DEffect(
                            .degrees(Double(dragOffset.width / 15)),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .rotation3DEffect(
                            .degrees(Double(-dragOffset.height / 15)),
                            axis: (x: 1.0, y: 0.0, z: 0.0)
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    withAnimation(.interactiveSpring()) {
                                        dragOffset = value.translation
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        dragOffset = .zero
                                    }
                                }
                        )
                    }
                    
                    // Alias Name Input Box
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Choose a card holder name (alias)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white.opacity(0.8))
                        
                        TextField("", text: $data.aliasName, prompt: Text("Enter your card alias").foregroundColor(.white.opacity(0.3)))
                            .focused($isAliasFocused)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .frame(height: 50)
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(Theme.Radius.md)
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.Radius.md)
                                    .stroke(isAliasFocused ? Color.theme.accentPrimary : Color.white.opacity(0.12), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, Theme.Spacing.lg)
                    .padding(.top, Theme.Spacing.md)
                    
                    if isFormValid {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.theme.accentPrimary)
                            Text("Card Forge Unlocked")
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
                .padding(.bottom, 24)
            }
            
            Spacer()
            
            // Primary button (SOLID yellow)
            Button(action: onNext) {
                Text("Looks good")
            }
            .buttonStyle(PremiumButtonStyle(isEnabled: isFormValid))
            .disabled(!isFormValid)
            .padding(.horizontal, Theme.Spacing.xxl)
            .padding(.bottom, Theme.Spacing.xxl)
        }
        .background(Color.theme.canvas.ignoresSafeArea())
    }
}

#Preview {
    OnboardingCardCustomizationView(data: .constant(OnboardingData(firstName: "Daniel", lastName: "")), onNext: {}, onBack: {})
}
