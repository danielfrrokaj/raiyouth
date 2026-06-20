import SwiftUI

struct AccountDetailsSheetView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .top) {
            Color.theme.canvas.ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: Theme.Spacing.lg) {
                    
                    // Drag handle
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 40, height: 4)
                        .padding(.top, 12)
                    
                    HStack {
                        Text("Account Details")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal, Theme.Spacing.lg)
                    
                    VStack(spacing: 0) {
                        AccountDetailRow(title: "Account holder", value: "Daniel Doe", canCopy: false)
                        
                        Divider().background(Color.white.opacity(0.1)).padding(.horizontal, Theme.Spacing.lg)
                        
                        AccountDetailRow(title: "IBAN", value: "AL12 2121 0000 0000 1234 5678 90", canCopy: true)
                        
                        Divider().background(Color.white.opacity(0.1)).padding(.horizontal, Theme.Spacing.lg)
                        
                        AccountDetailRow(title: "BIC / SWIFT", value: "RZBAALTR", canCopy: true)
                        
                        Divider().background(Color.white.opacity(0.1)).padding(.horizontal, Theme.Spacing.lg)
                        
                        AccountDetailRow(title: "Bank name", value: "Raiffeisen Bank Albania", canCopy: false)
                        
                        Divider().background(Color.white.opacity(0.1)).padding(.horizontal, Theme.Spacing.lg)
                        
                        AccountDetailRow(title: "Bank address", value: "Bulevardi Bajram Curri, Tirana", canCopy: false)
                    }
                    .background(Color.theme.surface2)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
                    .padding(.horizontal, Theme.Spacing.lg)
                    
                    Spacer()
                }
            }
        }
    }
}

struct AccountDetailRow: View {
    let title: String
    let value: String
    let canCopy: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color.theme.textSecondary)
                
                Text(value)
                    .font(.system(size: 15, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            if canCopy {
                Button(action: {
                    UIPasteboard.general.string = value.replacingOccurrences(of: " ", with: "")
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.theme.accentPrimary)
                        .padding(8)
                        .background(Color.theme.accentPrimary.opacity(0.15))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.vertical, Theme.Spacing.md)
        .padding(.horizontal, Theme.Spacing.lg)
    }
}
