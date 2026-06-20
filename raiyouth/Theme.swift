//
//  Theme.swift
//  raiyouth
//

import SwiftUI

extension Color {
    static let theme = Theme.Colors()
}

struct Theme {
    struct Colors {
        // Canvas & Surfaces
        let canvas = Color(hex: "24272C")
        let surfaceCard = Color(hex: "111316")
        let surface1 = Color(hex: "2C2F35")
        let surface2 = Color(hex: "34373E")
        let surface3 = Color(hex: "3D4047")
        let hairline = Color(hex: "484B52")
        
        // Glassmorphism Values
        let glassFill = Color.white.opacity(0.07)
        let glassFillStrong = Color.white.opacity(0.12)
        let glassTint = Color(hex: "282B31").opacity(0.55)
        let glassBorder = Color.white.opacity(0.15)
        let glassBorderStrong = Color.white.opacity(0.22)
        
        // Accents
        let accentPrimary = Color(hex: "FFD21E") // Yellow
        let accentPrimaryDeep = Color(hex: "E6A800") // Gold
        let accentTeal = Color(hex: "2C7A87") // Teal (KUIK, progress, goals)
        
        // Text
        let textPrimary = Color(hex: "FFFFFF")
        let textSecondary = Color(hex: "A6A9B0")
        let textTertiary = Color(hex: "70737A")
        let textOnAccentYellow = Color(hex: "1A1A14")
        let textOnAccentTeal = Color(hex: "FFFFFF")
        
        // Semantic
        let success = Color(hex: "3DD68C")
        let warning = Color(hex: "FF9F2E")
        let danger = Color(hex: "FF5A5A")
        let info = Color(hex: "2C7A87")
    }
    
    // Spacing scale
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
        static let giant: CGFloat = 40
    }
    
    // Corner Radius
    struct Radius {
        static let sm: CGFloat = 10     // Chips, inputs
        static let md: CGFloat = 14     // Buttons
        static let lg: CGFloat = 20     // Cards
        static let xl: CGFloat = 28     // Hero, sheets
        static let pill: CGFloat = 999  // Badges, navigation
    }
    
    // Motion Durations
    struct Motion {
        static let micro: Double = 0.12
        static let standard: Double = 0.22
        static let screenTransition: Double = 0.35
    }
}

// Helper to initialize Color from HEX string
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Typography View Modifiers
struct ThemeFont: ViewModifier {
    enum Style {
        case display(value: Double)
        case h1
        case h2
        case title
        case body
        case caption
        case micro
    }
    
    let style: Style
    
    func body(content: Content) -> some View {
        switch style {
        case .display(let value):
            content
                .font(.system(size: 32, weight: .semibold, design: .rounded))
                .tracking(-0.5)
                .lineSpacing(4)
                .environment(\.sizeCategory, .large) // tabulate numbers if applicable
        case .h1:
            content
                .font(.system(size: 24, weight: .semibold, design: .default))
                .lineSpacing(6)
        case .h2:
            content
                .font(.system(size: 20, weight: .semibold, design: .default))
                .lineSpacing(5)
        case .title:
            content
                .font(.system(size: 17, weight: .semibold, design: .default))
        case .body:
            content
                .font(.system(size: 15, weight: .regular, design: .default))
                .lineSpacing(6)
        case .caption:
            content
                .font(.system(size: 13, weight: .regular, design: .default))
        case .micro:
            content
                .font(.system(size: 12, weight: .medium, design: .default))
        }
    }
}

// Glassmorphism Modifier
struct GlassCardModifier: ViewModifier {
    let radius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    Color.black.opacity(0.55)
                    Color.white.opacity(0.04)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.28),
                                Color.white.opacity(0.06),
                                Color.black.opacity(0.08),
                                Color.white.opacity(0.10)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(0.25), radius: 16, x: 0, y: 6)
    }
}

// Premium Background Ambient Glows
struct AmbientGlowsModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AppStorage("accountTheme") private var accountTheme = "dark"
    
    private var glowAColor: Color {
        switch accountTheme {
        case "yellow": return Color(hex: "FFD21E")
        case "blue": return Color(hex: "2C7A87")
        case "purple": return Color(hex: "6A3093")
        case "green": return Color(hex: "11998e")
        case "crimson": return Color(hex: "E52D27")
        case "gray": return Color(hex: "484B52")
        default: return Color.theme.accentPrimary
        }
    }
    
    private var glowBColor: Color {
        switch accountTheme {
        case "blue": return Color(hex: "00B4D8")
        case "purple": return Color(hex: "A044FF")
        case "green": return Color(hex: "38ef7d")
        case "crimson": return Color(hex: "B31217")
        default: return Color.theme.accentTeal
        }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            Color.theme.canvas.ignoresSafeArea()
            
            if !reduceMotion {
                Circle()
                    .fill(glowAColor.opacity(0.08))
                    .frame(width: 320, height: 320)
                    .blur(radius: 80)
                    .position(x: UIScreen.main.bounds.width - 20, y: 80)
                    .animation(.easeInOut(duration: 0.5), value: accountTheme)
                
                Circle()
                    .fill(glowBColor.opacity(0.06))
                    .frame(width: 350, height: 350)
                    .blur(radius: 80)
                    .position(x: 20, y: UIScreen.main.bounds.height - 100)
                    .animation(.easeInOut(duration: 0.5), value: accountTheme)
            }
            
            content
        }
    }
}

// Custom Premium Solid Yellow Button Style
struct PremiumButtonStyle: ButtonStyle {
    let isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.theme.textOnAccentYellow)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.theme.accentPrimary)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous))
            .opacity(isEnabled ? 1.0 : 0.4)
            .animation(nil, value: configuration.isPressed)
    }
}

extension View {
    func themeFont(_ style: ThemeFont.Style) -> some View {
        modifier(ThemeFont(style: style))
    }
    
    func glassCard(radius: CGFloat = Theme.Radius.lg) -> some View {
        modifier(GlassCardModifier(radius: radius))
    }
    
    func ambientGlows() -> some View {
        modifier(AmbientGlowsModifier())
    }
}

// Custom Sentence Case string extension
extension String {
    var sentenceCased: String {
        guard !isEmpty else { return "" }
        let first = prefix(1).uppercased()
        let rest = dropFirst()
        return first + rest
    }
}
