import SwiftUI

struct CustomizeAccountSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var theme: String
    @State private var tempTheme: String = "dark"

    let themes = [
        ("dark", Color.black, "Dark Mode"),
        ("yellow", Color.theme.accentPrimary, "Raiffeisen Yellow"),
        ("blue", Color(hex: "2C7A87"), "Ocean Blue"),
        ("purple", Color(hex: "6A3093"), "Midnight Violet"),
        ("green", Color(hex: "11998e"), "Emerald Forest"),
        ("crimson", Color(hex: "E52D27"), "Sunset Crimson"),
        ("gray", Color.theme.surface2, "Slate Gray")
    ]

    var body: some View {
        ZStack(alignment: .top) {
            Color.theme.canvas.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: Theme.Spacing.xl) {

                    // Header
                    HStack {
                        Text("Customize Account")
                            .themeFont(.h2)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal, Theme.Spacing.lg)
                    .padding(.top, Theme.Spacing.xxl)

                    // Account Card Preview
                    VStack(spacing: Theme.Spacing.md) {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Primary Account")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                    Text("120.00 ALL")
                                        .font(.system(size: 34, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                Text("🇦🇱")
                                    .font(.system(size: 32))
                                    .shadow(radius: 2)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("IBAN")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(textColor.opacity(0.5))
                                    .textCase(.uppercase)
                                Text("AL12 2121 0000 0000 1234 5678 90")
                                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                                    .foregroundColor(textColor)
                            }
                        }
                        .padding(Theme.Spacing.xl)
                        .background(cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
                        .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 8)
                        .padding(.horizontal, Theme.Spacing.lg)
                    }

                    // Theme Picker
                    VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                        Text("Color Theme")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, Theme.Spacing.lg)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Theme.Spacing.md) {
                                ForEach(themes, id: \.0) { themeOption in
                                    let isActive = tempTheme == themeOption.0
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            tempTheme = themeOption.0
                                        }
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    }) {
                                        VStack(spacing: 8) {
                                            ZStack {
                                                Circle()
                                                    .fill(themeOption.1)
                                                    .frame(width: 56, height: 56)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(isActive ? Color.theme.accentPrimary : Color.white.opacity(0.2), lineWidth: isActive ? 3 : 1)
                                                    )
                                                if isActive {
                                                    Image(systemName: "checkmark")
                                                        .font(.system(size: 20, weight: .bold))
                                                        .foregroundColor(themeOption.0 == "yellow" || themeOption.0 == "white" ? Color(hex: "1A1A14") : .white)
                                                }
                                            }

                                            Text(themeOption.2)
                                                .font(.system(size: 12, weight: isActive ? .semibold : .regular))
                                                .foregroundColor(isActive ? .white : .white.opacity(0.6))
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, Theme.Spacing.lg)
                        }
                    }

                    Spacer().frame(height: 40)

                    // Save Button
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        theme = tempTheme
                        dismiss()
                    }) {
                        Text("Save Changes")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "1A1A14"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.theme.accentPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, Theme.Spacing.lg)

                    Spacer().frame(height: 40)
                }
            }

            // Drag handle
            VStack(spacing: 0) {
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 36, height: 4)
                    .padding(.top, 12)
            }
        }
        .onAppear {
            tempTheme = theme
        }
    }

    private var cardBackground: some View {
        Group {
            switch tempTheme {
            case "dark":
                LinearGradient(colors: [Color(hex: "24272C"), Color(hex: "111316")], startPoint: .topLeading, endPoint: .bottomTrailing)
            case "yellow":
                LinearGradient(colors: [Color(hex: "FFD21E"), Color(hex: "E6A800")], startPoint: .topLeading, endPoint: .bottomTrailing)
            case "blue":
                LinearGradient(colors: [Color(hex: "2C7A87"), Color(hex: "1F5660")], startPoint: .topLeading, endPoint: .bottomTrailing)
            case "purple":
                LinearGradient(colors: [Color(hex: "6A3093"), Color(hex: "A044FF")], startPoint: .topLeading, endPoint: .bottomTrailing)
            case "green":
                LinearGradient(colors: [Color(hex: "11998e"), Color(hex: "38ef7d")], startPoint: .topLeading, endPoint: .bottomTrailing)
            case "crimson":
                LinearGradient(colors: [Color(hex: "E52D27"), Color(hex: "B31217")], startPoint: .topLeading, endPoint: .bottomTrailing)
            case "gray":
                LinearGradient(colors: [Color(hex: "34373E"), Color(hex: "1E2125")], startPoint: .topLeading, endPoint: .bottomTrailing)
            default:
                LinearGradient(colors: [Color(hex: "24272C"), Color(hex: "111316")], startPoint: .topLeading, endPoint: .bottomTrailing)
            }
        }
    }

    private var textColor: Color {
        switch tempTheme {
        case "yellow": return Color(hex: "1A1A14")
        default: return .white
        }
    }
}
