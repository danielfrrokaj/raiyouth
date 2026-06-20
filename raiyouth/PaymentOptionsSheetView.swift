import SwiftUI

struct PaymentOptionsSheetView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .top) {
            Color.theme.canvas.ignoresSafeArea()
            
            VStack(spacing: Theme.Spacing.lg) {
                // Drag handle
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 40, height: 4)
                    .padding(.top, 12)
                
                HStack {
                    Text("Payment")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, Theme.Spacing.lg)
                
                VStack(spacing: Theme.Spacing.md) {
                    PaymentOptionRow(
                        icon: "building.columns.fill",
                        title: "In bank transfer",
                        subtitle: "Send to another RaiYouth or Raiffeisen account instantly",
                        color: Color.theme.accentPrimary
                    )
                    
                    PaymentOptionRow(
                        icon: "building.2.fill",
                        title: "Domestic transfer",
                        subtitle: "Send outside bank to domestic Albanian accounts",
                        color: Color(hex: "5A8AE2")
                    )
                    
                    PaymentOptionRow(
                        icon: "globe.europe.africa.fill",
                        title: "World wide",
                        subtitle: "International transfers using SWIFT",
                        color: Color.theme.success
                    )
                }
                .padding(.horizontal, Theme.Spacing.lg)
                
                Spacer()
            }
        }
    }
}

struct PaymentOptionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            // Action to be implemented
        }) {
            HStack(spacing: Theme.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color.theme.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.white.opacity(0.3))
            }
            .padding(Theme.Spacing.md)
            .background(Color.theme.surface2)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous))
        }
        .buttonStyle(PlainButtonStyle())
    }
}
