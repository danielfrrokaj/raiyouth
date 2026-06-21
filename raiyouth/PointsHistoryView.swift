import SwiftUI

struct PointsHistoryView: View {
    let basePoints: Int
    let kuikSimulatedReceivedAmount: Double
    var highlightedMissionId: String? = nil

    @AppStorage("kuikMissionCollected") private var kuikMissionCollected = false
    @Environment(\.dismiss) private var dismiss

    @State private var animateProgress = false
    @State private var animateItems = false
    @State private var pulseBadge = false
    @State private var shownItems: Set<Int> = []
    @State private var coinAnimating = false

    private let levelCurrent = 2
    private let levelNext = 3
    private let pointsForCurrentLevel = 200
    private let pointsForNextLevel = 500

    private var totalPoints: Int {
        basePoints + (kuikMissionCollected ? 200 : 0)
    }

    private var levelProgress: Double {
        let range = Double(pointsForNextLevel - pointsForCurrentLevel)
        let earned = Double(totalPoints - pointsForCurrentLevel)
        return min(max(earned / range, 0), 1)
    }

    private struct Mission {
        let id: String
        let title: String
        let subtitle: String
        let reward: Int
        let icon: String
        let isActive: Bool
        var isCompleted: Bool = false
        var isCollected: Bool = false
    }

    private var missions: [Mission] {
        let kuikDone = kuikSimulatedReceivedAmount > 0
        return [
            Mission(id: "kuik", title: "Receive your first Kuik transfer", subtitle: "Get money from a friend or family using Kuik.", reward: 200, icon: "creditcard",
                    isActive: kuikDone && !kuikMissionCollected,
                    isCompleted: kuikDone,
                    isCollected: kuikMissionCollected),
            Mission(id: "card",    title: "Apply for your debit card",     subtitle: "Order your physical card and start spending.",   reward: 250, icon: "creditcard.fill", isActive: false),
            Mission(id: "invite",  title: "Invite a friend",               subtitle: "Invite a friend and he signs up.",              reward: 400, icon: "person.2.fill",   isActive: false),
            Mission(id: "purchase",title: "Make your first purchase",      subtitle: "Pay in-store or online with your card.",         reward: 300, icon: "bag.fill",        isActive: false)
        ]
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "111316").ignoresSafeArea()

            Circle()
                .fill(Color(hex: "FFD21E").opacity(0.12))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .offset(x: 80, y: -60)
                .allowsHitTesting(false)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Hero
                    VStack(spacing: Theme.Spacing.lg) {
                        Image("level_2_badge")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .shadow(color: Color(hex: "FFD21E").opacity(pulseBadge ? 0.6 : 0.2), radius: pulseBadge ? 24 : 10, x: 0, y: 0)
                            .scaleEffect(pulseBadge ? 1.04 : 1.0)
                            .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: pulseBadge)
                            .padding(.top, 60)

                        VStack(spacing: 8) {
                            RaiCoinView(size: 64, isAnimating: coinAnimating)

                            Text("\(totalPoints)")
                                .font(.system(size: 52, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .monospacedDigit()
                                .shadow(color: Color(hex: "FFD21E").opacity(0.3), radius: 12)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: totalPoints)
                            Text("RaiPoints")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.5))
                                .tracking(2)
                                .textCase(.uppercase)
                        }

                        VStack(spacing: 8) {
                            HStack {
                                Text("Level \(levelCurrent)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.5))
                                Spacer()
                                Text("\(pointsForNextLevel - totalPoints) pts to Level \(levelNext)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(hex: "FFD21E"))
                            }

                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color.white.opacity(0.1))
                                        .frame(height: 8)
                                    Capsule()
                                        .fill(LinearGradient(colors: [Color(hex: "FFD21E"), Color(hex: "FF9F2E")], startPoint: .leading, endPoint: .trailing))
                                        .frame(width: animateProgress ? geo.size.width * levelProgress : 0, height: 8)
                                        .animation(.spring(response: 1.1, dampingFraction: 0.72).delay(0.3), value: animateProgress)
                                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: levelProgress)
                                }
                            }
                            .frame(height: 8)
                        }
                        .padding(.horizontal, Theme.Spacing.lg)

                        HStack(spacing: 0) {
                            StatPill(value: "7", label: "Day streak", icon: "flame.fill", color: Color(hex: "FF9F2E"))
                            Divider().background(Color.white.opacity(0.1)).frame(height: 32)
                            StatPill(value: "Lv \(levelCurrent)", label: "Current rank", icon: "trophy.fill", color: Color(hex: "FFD21E"))
                            Divider().background(Color.white.opacity(0.1)).frame(height: 32)
                            StatPill(value: "1", label: "Referral", icon: "person.2.fill", color: Color(hex: "3DD68C"))
                        }
                        .padding(.vertical, Theme.Spacing.md)
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous).stroke(Color.white.opacity(0.1), lineWidth: 1))
                        .padding(.horizontal, Theme.Spacing.lg)
                    }

                    // Missions list
                    VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                        Text("Your missions")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, Theme.Spacing.lg)
                            .padding(.top, Theme.Spacing.xxl)
                            .padding(.bottom, Theme.Spacing.xs)

                        ForEach(Array(missions.enumerated()), id: \.offset) { index, item in
                            MissionRow(
                                title: item.title,
                                subtitle: item.subtitle,
                                reward: item.reward,
                                icon: item.icon,
                                isActive: highlightedMissionId == nil ? item.isActive : (item.id == highlightedMissionId),
                                isCompleted: item.isCompleted,
                                isCollected: item.isCollected,
                                visible: shownItems.contains(index),
                                onCollect: item.id == "kuik" && item.isCompleted && !item.isCollected ? {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                                        kuikMissionCollected = true
                                    }
                                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                                    coinAnimating = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { coinAnimating = false }
                                } : nil
                            )
                            .padding(.horizontal, Theme.Spacing.lg)
                        }
                    }
                    .padding(.bottom, 60)
                }
            }

            VStack(spacing: 0) {
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 36, height: 4)
                    .padding(.top, 12)
            }
        }
        .onAppear {
            animateProgress = true
            pulseBadge = true

            for index in missions.indices {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.55 + Double(index) * 0.08) {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.72)) {
                        _ = shownItems.insert(index)
                    }
                }
            }
        }
    }
}

private struct StatPill: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(color)
                Text(value)
                    .font(.system(size: 15, weight: .black, design: .rounded))
                    .foregroundColor(.white)
            }
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
    }
}

private struct MissionRow: View {
    let title: String
    let subtitle: String
    let reward: Int
    let icon: String
    let isActive: Bool
    var isCompleted: Bool = false
    var isCollected: Bool = false
    let visible: Bool
    var onCollect: (() -> Void)? = nil

    private var borderColor: Color {
        if isCollected { return Color.white.opacity(0.06) }
        if isCompleted { return Color(hex: "3DD68C").opacity(0.6) }
        if isActive    { return Color(hex: "FFD21E").opacity(0.5) }
        return Color.white.opacity(0.08)
    }

    private var glowColor: Color {
        if isCompleted && !isCollected { return Color(hex: "3DD68C").opacity(0.18) }
        if isActive                    { return Color(hex: "FFD21E").opacity(0.15) }
        return Color.clear
    }

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(isCollected ? Color.white.opacity(0.08) : Color(hex: "FFD21E"))
                    .frame(width: 64, height: 64)
                Image(systemName: isCollected ? "checkmark" : icon)
                    .font(.system(size: isCollected ? 22 : 28, weight: .bold))
                    .foregroundColor(isCollected ? Color(hex: "3DD68C") : Color(hex: "1A1A14"))
                    .frame(width: 64, height: 64)

                if icon == "creditcard" && !isCollected {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(hex: "FFD21E"))
                        .background(Circle().fill(Color(hex: "1A1A14")).frame(width: 16, height: 16))
                        .offset(x: 4, y: 4)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isCollected ? .white.opacity(0.45) : .white)
                    .fixedSize(horizontal: false, vertical: true)
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(isCollected ? 0.3 : 0.6))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
            }

            Spacer(minLength: 8)

            if isCompleted && !isCollected {
                Button(action: { onCollect?() }) {
                    VStack(spacing: 2) {
                        Text("Collect")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(hex: "1A1A14"))
                        Text("+\(reward)")
                            .font(.system(size: 18, weight: .black, design: .rounded))
                            .foregroundColor(Color(hex: "1A1A14"))
                        Text("pts")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(Color(hex: "1A1A14").opacity(0.7))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(hex: "3DD68C"))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(PlainButtonStyle())
            } else if isCollected {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Collected")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(hex: "3DD68C").opacity(0.7))
                    Text("+\(reward)")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundColor(.white.opacity(0.3))
                    Text("pts")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.2))
                }
            } else {
                VStack(alignment: .leading, spacing: 2) {
                    Text("REWARD")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(hex: "FFD21E"))
                        .textCase(.uppercase)
                    Text("+\(reward)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Text("RaiPoints")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: "FFD21E"))
                    .padding(.leading, 4)
            }
        }
        .padding(Theme.Spacing.md)
        .background(Color(hex: "1A1A1C"))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(borderColor, lineWidth: isCompleted || isActive ? 1.5 : 1)
        )
        .shadow(color: glowColor, radius: 10, x: 0, y: 0)
        .opacity(visible ? 1 : 0)
        .offset(y: visible ? 0 : 18)
    }
}
