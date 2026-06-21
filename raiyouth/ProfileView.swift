import SwiftUI

struct ProfileView: View {
    @AppStorage("userFullName") private var userFullName = ""
    @AppStorage("userIntent") private var userIntent = ""
    @AppStorage("userPersona") private var userPersona = ""
    @AppStorage("userCardColor") private var userCardColor = "yellow"
    @AppStorage("userSignupRewardAmount") private var userSignupRewardAmount = 0.0
    @AppStorage("userKYCStatus") private var userKYCStatus = ""

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.theme.canvas.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: Theme.Spacing.xxl) {

                    // Avatar + name header
                    VStack(spacing: Theme.Spacing.md) {
                        let initials = userFullName
                            .split(separator: " ")
                            .compactMap { $0.first }
                            .map { String($0) }
                            .joined()
                            .uppercased()

                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.theme.accentPrimary, Color.theme.accentPrimaryDeep],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .shadow(color: Color.theme.accentPrimary.opacity(0.4), radius: 16, x: 0, y: 6)

                            Text(initials.isEmpty ? "DF" : initials)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }

                        VStack(spacing: 4) {
                            Text(userFullName.sentenceCased)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)

                            Text("Standard plan")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.theme.textSecondary)
                        }
                    }
                    .padding(.top, Theme.Spacing.xl)

                    // KYC Verification — prominent status card
                    KYCStatusCard(kycStatus: userKYCStatus)
                        .padding(.horizontal, Theme.Spacing.lg)

                    // Account details
                    ProfileSection(title: "Account") {
                        ProfileRow(icon: "person.fill", label: "Full name", value: userFullName.sentenceCased)
                        Divider().background(Color.white.opacity(0.07))
                        ProfileRow(icon: "target", label: "Financial goal", value: intentLabel)
                        Divider().background(Color.white.opacity(0.07))
                        ProfileRow(icon: "sparkles", label: "Profile type", value: userPersona.sentenceCased)
                        Divider().background(Color.white.opacity(0.07))
                        ProfileRow(icon: "creditcard.fill", label: "Card", value: cardLabel)
                    }
                    .padding(.horizontal, Theme.Spacing.lg)

                    // Points
                    ProfileSection(title: "RaiPoints") {
                        ProfileRow(
                            icon: "hexagon.fill",
                            label: "Balance",
                            value: "\(Int(300 + userSignupRewardAmount)) pts",
                            valueColor: Color.theme.accentPrimary
                        )
                        Divider().background(Color.white.opacity(0.07))
                        ProfileRow(icon: "trophy.fill", label: "Level", value: "Level 2")
                    }
                    .padding(.horizontal, Theme.Spacing.lg)

                    // Support
                    ProfileSection(title: "Support") {
                        ProfileRow(icon: "questionmark.circle.fill", label: "Help centre", value: "")
                        Divider().background(Color.white.opacity(0.07))
                        ProfileRow(icon: "lock.shield.fill", label: "Privacy policy", value: "")
                        Divider().background(Color.white.opacity(0.07))
                        ProfileRow(icon: "doc.text.fill", label: "Terms of service", value: "")
                    }
                    .padding(.horizontal, Theme.Spacing.lg)

                    Spacer().frame(height: Theme.Spacing.xxl)
                }
            }

            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 34, height: 34)
                            Image(systemName: "xmark")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.trailing, Theme.Spacing.lg)
                    .padding(.top, Theme.Spacing.lg)
                }
                Spacer()
            }
        }
    }

    private var intentLabel: String {
        switch userIntent {
        case "save money":     return "Save money"
        case "spend wisely":   return "Spend wisely"
        case "learn investing": return "Learn investing"
        default:               return "General savings"
        }
    }

    private var cardLabel: String {
        switch userCardColor {
        case "yellow": return "Yellow — Signature"
        case "black":  return "Black — Noir"
        case "white":  return "White — Frost"
        default:       return userCardColor.sentenceCased
        }
    }
}

// MARK: - KYC Status Card

struct KYCStatusCard: View {
    let kycStatus: String

    var isVerified: Bool { kycStatus == "verified" }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack(spacing: Theme.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(isVerified ? Color.theme.success.opacity(0.15) : Color.theme.warning.opacity(0.15))
                        .frame(width: 48, height: 48)
                    Image(systemName: isVerified ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
                        .font(.system(size: 22))
                        .foregroundColor(isVerified ? .theme.success : .theme.warning)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text("KYC Verification")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text(isVerified ? "Your identity is verified" : "Your identity hasn't been verified yet")
                        .font(.system(size: 12))
                        .foregroundColor(.theme.textSecondary)
                }

                Spacer()

                if isVerified {
                    Text("Verified")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.theme.success)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.theme.success.opacity(0.15))
                        .clipShape(Capsule())
                }
            }

            if !isVerified {
                Divider().background(Color.white.opacity(0.08))

                HStack(spacing: Theme.Spacing.sm) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 13))
                        .foregroundColor(.theme.warning)
                    Text("Some features are limited until you verify. It only takes a minute.")
                        .font(.system(size: 12))
                        .foregroundColor(.theme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "camera.fill")
                        Text("Verify my identity")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(Color.theme.textOnAccentYellow)
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(Color.theme.accentPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(Theme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(isVerified ? Color.theme.success.opacity(0.06) : Color.theme.warning.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .stroke(isVerified ? Color.theme.success.opacity(0.25) : Color.theme.warning.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Reusable section + row

struct ProfileSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text(title.uppercased())
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.theme.textTertiary)
                .tracking(1.2)
                .padding(.leading, Theme.Spacing.sm)

            VStack(spacing: 0) {
                content
            }
            .padding(.horizontal, Theme.Spacing.md)
            .background(Color.white.opacity(0.04))
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                    .stroke(Color.white.opacity(0.07), lineWidth: 1)
            )
        }
    }
}

struct ProfileRow: View {
    let icon: String
    let label: String
    let value: String
    var valueColor: Color = Color.theme.textSecondary

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.theme.textSecondary)
                .frame(width: 20)

            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)

            Spacer()

            if !value.isEmpty {
                Text(value)
                    .font(.system(size: 13))
                    .foregroundColor(valueColor)
            } else {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.theme.textTertiary)
            }
        }
        .padding(.vertical, 14)
    }
}

#Preview {
    ProfileView()
}
