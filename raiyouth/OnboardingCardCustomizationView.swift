//
//  OnboardingCardCustomizationView.swift
//  raiyouth
//

import SwiftUI

struct OnboardingCardCustomizationView: View {
    @Binding var data: OnboardingData
    let onNext: () -> Void
    let onBack: () -> Void
    
    // Drag state for the 3D tilt effect
    @State private var dragOffset: CGSize = .zero
    
    // Card styles
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
                speechBubbleText: "Let's design your debit card. Pick a color that matches your vibe.",
                isHeroSize: false
            )
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.md)
            
            Spacer()
            
            // Interactive Debit Card Preview (3D tilt on drag)
            let selectedCardColor = CardColor(rawValue: data.cardColor) ?? .yellow
            
            VStack(spacing: Theme.Spacing.xxl) {
                // Card View with 3D Tilt Effect
                VStack(alignment: .leading) {
                    HStack {
                        if selectedCardColor == .yellow {
                            Spacer()
                            Image(systemName: "wave.3.right")
                                .font(.system(size: 16, weight: .semibold))
                                .rotationEffect(.degrees(-90))
                        } else {
                            Text("rai")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .italic()
                            + Text("youth")
                                .font(.system(size: 20, weight: .regular, design: .rounded))
                            
                            Spacer()
                            
                            Image(systemName: "wave.3.right")
                                .font(.system(size: 16, weight: .semibold))
                                .rotationEffect(.degrees(-90))
                        }
                    }
                    .foregroundColor(selectedCardColor.textColor)
                    
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
                    
                    // Card numbers formatted using SF Pro Display/Rounded, tabular figures, tracking -0.5
                    Text("4218  9012  5542  \(String(format: "%04d", Calendar.current.component(.year, from: Date())))")
                        .font(.system(size: 19, weight: .medium, design: .monospaced))
                        .tracking(-0.5)
                        .foregroundColor(selectedCardColor.textColor)
                        .padding(.bottom, Theme.Spacing.xs)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Card holder")
                                .themeFont(.micro)
                                .foregroundColor(selectedCardColor.secondaryTextColor)
                            Text(data.fullName.isEmpty ? "Your name" : data.fullName.sentenceCased)
                                .themeFont(.title)
                                .foregroundColor(selectedCardColor.textColor)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Expires")
                                .themeFont(.micro)
                                .foregroundColor(selectedCardColor.secondaryTextColor)
                            Text("06/31")
                                .themeFont(.title)
                                .foregroundColor(selectedCardColor.textColor)
                        }
                    }
                }
                .padding(Theme.Spacing.xxl)
                .frame(width: 320, height: 200)
                .background(
                    Group {
                        if selectedCardColor == .yellow {
                            Image("card")
                                .resizable()
                                .scaledToFill()
                        } else {
                            selectedCardColor.gradient
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.4), radius: 20, x: 0, y: 10)
                // 3D rotation based on drag offset
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
                
                // Color Swatches
                HStack(spacing: Theme.Spacing.xxl) {
                    ForEach(CardColor.allCases, id: \.self) { color in
                        Button(action: {
                            withAnimation(.spring(response: 0.22, dampingFraction: 0.8)) {
                                data.cardColor = color.rawValue
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(color.gradient)
                                    .frame(width: 48, height: 48)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                
                                if data.cardColor == color.rawValue {
                                    Circle()
                                        .stroke(Color.theme.accentPrimary, lineWidth: 3)
                                        .frame(width: 58, height: 58)
                                        .transition(.scale.combined(with: .opacity))
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.top, Theme.Spacing.md)
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            Spacer()
            
            // Primary button (SOLID yellow)
            Button(action: onNext) {
                Text("Looks good")
            }
            .buttonStyle(PremiumButtonStyle(isEnabled: true))
            .padding(.horizontal, Theme.Spacing.xxl)
            .padding(.bottom, Theme.Spacing.xxl)
        }
        .ambientGlows()
    }
}

#Preview {
    OnboardingCardCustomizationView(data: .constant(OnboardingData(firstName: "Daniel", lastName: "")), onNext: {}, onBack: {})
}
