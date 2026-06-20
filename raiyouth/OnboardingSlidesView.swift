//
//  OnboardingSlidesView.swift
//  raiyouth
//

import SwiftUI

struct OnboardingSlidesView: View {
    let onSignUp: () -> Void
    let onLogIn: () -> Void
    
    @State private var activeSlide = 0
    @State private var pulseScale: CGFloat = 1.0
    
    private let slides = [
        SlideData(
            title: "Ready to change the way you money?",
            description: "Join the digital banking revolution tailored for the next generation.",
            imageName: "gift-3d", // Reuses our 3D gift asset
            systemIcon: "square.stack.3d.up.fill"
        ),
        SlideData(
            title: "Spend & save your way, securely",
            description: "Track your funds, get rewards, and customize your debit card style.",
            imageName: "slide2_welcoming",
            systemIcon: "creditcard.fill"
        ),
        SlideData(
            title: "Your wealth, protected — period.",
            description: "Encrypted end-to-end with biometric access and instant lock control.",
            imageName: "rai-security", // Reuses our custom shield/security asset
            systemIcon: "lock.shield.fill"
        )
    ]
    
    struct SlideData {
        let title: String
        let description: String
        let imageName: String
        let systemIcon: String
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Multi-segment horizontal page indicator
            HStack(spacing: 6) {
                ForEach(0..<slides.count, id: \.self) { index in
                    Rectangle()
                        .fill(index == activeSlide ? Color.white : Color.white.opacity(0.2))
                        .frame(height: 3)
                        .cornerRadius(1.5)
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.lg)
            
            // TabView for swipe-able content
            TabView(selection: $activeSlide) {
                ForEach(0..<slides.count, id: \.self) { index in
                    Group {
                        if index == 1 {
                            // Slide 2: Full-bleed welcoming hero image
                            ZStack(alignment: .bottom) {
                                Image(slides[index].imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .clipped()
                                    .allowsHitTesting(false)
                                
                                // Gradient scrim so text stays readable
                                VStack(spacing: Theme.Spacing.md) {
                                    Text(slides[index].title)
                                        .font(.system(size: 28, weight: .black, design: .rounded))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(4)
                                        .padding(.horizontal, Theme.Spacing.lg)
                                    
                                    Text(slides[index].description)
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(.white.opacity(0.75))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, Theme.Spacing.xl)
                                }
                                .padding(.bottom, Theme.Spacing.xl)
                                .background(
                                    LinearGradient(
                                        colors: [.clear, Color.theme.canvas.opacity(0.85), Color.theme.canvas],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                    .padding(.top, -80)
                                )
                            }
                        } else {
                            // Slides 1 & 3: icon-in-glow-circle layout
                            VStack(spacing: Theme.Spacing.xl) {
                                Spacer()
                                
                                ZStack {
                                    Circle()
                                        .fill(Color.theme.accentPrimary.opacity(0.08))
                                        .frame(width: 220, height: 220)
                                        .blur(radius: 20)
                                        .scaleEffect(pulseScale)
                                        .onAppear {
                                            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                                pulseScale = 1.2
                                            }
                                        }
                                    
                                    Image(slides[index].imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 160, height: 160)
                                        .shadow(color: Color.theme.accentPrimary.opacity(0.2), radius: 15)
                                        .fallback(systemName: slides[index].systemIcon)
                                }
                                .frame(height: 240)
                                
                                VStack(spacing: Theme.Spacing.md) {
                                    Text(slides[index].title)
                                        .font(.system(size: 28, weight: .black, design: .rounded))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(4)
                                        .padding(.horizontal, Theme.Spacing.lg)
                                    
                                    Text(slides[index].description)
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(.theme.textSecondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, Theme.Spacing.xl)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Buttons at the bottom
            HStack(spacing: Theme.Spacing.md) {
                Button(action: onLogIn) {
                    Text("Log in")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(Theme.Radius.md)
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.md)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                }
                
                Button(action: onSignUp) {
                    Text("Sign up")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.theme.textOnAccentYellow)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.theme.accentPrimary)
                        .cornerRadius(Theme.Radius.md)
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.xl + 10)
        }
        .background(Color.theme.canvas.ignoresSafeArea())
        .ambientGlows()
    }
}

// Fallback Helper View Modifer to safely handle cases where asset loading is delayed
extension View {
    @ViewBuilder
    func fallback(systemName: String) -> some View {
        self.overlay(
            Image(systemName: systemName)
                .font(.system(size: 80))
                .foregroundColor(.theme.accentPrimary)
                .opacity(0.2)
        )
    }
}

#Preview {
    OnboardingSlidesView(onSignUp: {}, onLogIn: {})
}
