//
//  OnboardingSlidesView.swift
//  raiyouth
//

import SwiftUI

struct OnboardingSlidesView: View {
    let onSignUp: () -> Void
    let onLogIn: () -> Void

    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Hero image
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

                Image("raipoints")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
                    .shadow(color: Color.theme.accentPrimary.opacity(0.2), radius: 15)
            }
            .frame(height: 240)

            Spacer().frame(height: Theme.Spacing.xl)

            // Copy
            VStack(spacing: Theme.Spacing.md) {
                Text("Ready to change the way you money?")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, Theme.Spacing.lg)

                Text("Join the digital banking revolution tailored for the next generation.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.xl)
            }

            Spacer()

            // Buttons
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
