import SwiftUI

struct OnboardingNotificationsView: View {
    let onNext: () -> Void
    let onBack: () -> Void
    
    @State private var scale: CGFloat = 1.0
    
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
                Text("Stay in the loop")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.theme.textPrimary)
                    .padding(.top, Theme.Spacing.lg)

                Text("Get instant alerts for payments, transfers, and security events — so nothing catches you off guard.")
                    .themeFont(.body)
                    .foregroundColor(.theme.textSecondary)
                    .lineSpacing(4)
                
                Spacer()
                
                // 3D Phone and Bell Graphic
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color.theme.accentTeal.opacity(0.08))
                            .frame(width: 240, height: 240)
                            .blur(radius: 20)
                        
                        // Combined phone illustration overlay
                        Image("rai-phone")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .shadow(color: Color.theme.accentTeal.opacity(0.2), radius: 10)
                            .scaleEffect(scale)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                                    scale = 1.06
                                }
                            }
                        
                        // Floating bell
                        Image(systemName: "bell.and.waves.left.and.right.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.theme.accentPrimary)
                            .padding(14)
                            .background(Color.theme.surface3)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 2, y: 4)
                            .offset(x: 50, y: 50)
                    }
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            // Actions
            VStack(spacing: Theme.Spacing.md) {
                Button(action: {
                    onNext()
                }) {
                    Text("Enable push notifications")
                }
                .buttonStyle(PremiumButtonStyle(isEnabled: true))
                
                Button(action: onNext) {
                    Text("Not now")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(Theme.Radius.md)
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.xl)
        }
        .background(Color.theme.canvas.ignoresSafeArea())
    }
}

#Preview {
    OnboardingNotificationsView(onNext: {}, onBack: {})
}
