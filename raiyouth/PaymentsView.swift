import SwiftUI

struct PaymentsView: View {

    struct Transaction: Identifiable {
        let id = UUID()
        let merchant: String
        let date: String
        let category: String
        let amount: Double
        let isIncome: Bool
        var isSystemIcon: Bool = true
        let icon: String
        let iconColor: Color
    }

    let transactions: [Transaction] = [
        Transaction(merchant: "Mon Cheri",             date: "Today, 10:15 AM", category: "Food",          amount: -4.50,  isIncome: false, isSystemIcon: false, icon: "moncheri", iconColor: .clear),
        Transaction(merchant: "App Store",             date: "Today, 8:02 AM",  category: "Entertainment", amount: -9.99,  isIncome: false, isSystemIcon: false, icon: "appstore", iconColor: .clear),
        Transaction(merchant: "Received from Dad",     date: "June 18",         category: "Transfer",      amount: 50.00,  isIncome: true,  icon: "arrow.down.left.circle.fill",    iconColor: Color(hex: "3DD68C")),
        Transaction(merchant: "Spotify Premium",       date: "June 15",         category: "Entertainment", amount: -5.99,  isIncome: false, isSystemIcon: false, icon: "spotify", iconColor: .clear),
        Transaction(merchant: "Raiffeisen Interest",   date: "June 10",         category: "Savings",       amount: 0.12,   isIncome: true,  isSystemIcon: false, icon: "raiffeisen", iconColor: .clear),
    ]



    private var totalSpent: Double {
        transactions.filter { !$0.isIncome }.map { abs($0.amount) }.reduce(0, +)
    }

    private var totalIn: Double {
        transactions.filter { $0.isIncome }.map { $0.amount }.reduce(0, +)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                Spacer().frame(height: 50)

                // ── Summary card ──────────────────────────────────────────
                VStack(spacing: Theme.Spacing.lg) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Spent this month")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.5))
                                .textCase(.uppercase)
                                .kerning(0.6)
                            Text(String(format: "%.2f €", totalSpent))
                                .font(.system(size: 36, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .monospacedDigit()
                        }
                        Spacer()
                        // Net indicator pill
                        let net = totalIn - totalSpent
                        let isPositive = net >= 0
                        HStack(spacing: 4) {
                            Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                                .font(.system(size: 10, weight: .bold))
                            Text(String(format: "%@%.2f €", isPositive ? "+" : "", net))
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .monospacedDigit()
                        }
                        .foregroundColor(isPositive ? Color.theme.success : Color.theme.danger)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background((isPositive ? Color.theme.success : Color.theme.danger).opacity(0.12))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke((isPositive ? Color.theme.success : Color.theme.danger).opacity(0.25), lineWidth: 1))
                        .padding(.top, 4)
                    }

                    // In / Out row
                    HStack(spacing: Theme.Spacing.md) {
                        StatPill(label: "Money in", value: totalIn, color: Color.theme.success)
                        StatPill(label: "Money out", value: totalSpent, color: Color.theme.danger)
                    }
                }
                .padding(Theme.Spacing.xl)
                .glassCard(radius: Theme.Radius.lg)
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.bottom, Theme.Spacing.xl)

                // ── Transactions List ────────────────────────────────────
                VStack(spacing: Theme.Spacing.xxl) {
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        Text("Transactions")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white.opacity(0.35))
                            .textCase(.uppercase)
                            .kerning(0.8)
                            .padding(.horizontal, Theme.Spacing.lg)

                        VStack(spacing: 1) {
                            ForEach(Array(transactions.enumerated()), id: \.element.id) { idx, tx in
                                TransactionRow(tx: tx)
                                    .padding(.horizontal, Theme.Spacing.lg)

                                if idx < transactions.count - 1 {
                                    Rectangle()
                                        .fill(Color.white.opacity(0.05))
                                        .frame(height: 1)
                                        .padding(.horizontal, Theme.Spacing.lg + 56)
                                }
                            }
                        }
                        .background(Color.white.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.18), Color.white.opacity(0.04)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: Color.black.opacity(0.18), radius: 12, x: 0, y: 4)
                        .padding(.horizontal, Theme.Spacing.lg)
                    }
                }
                .padding(.bottom, 120)
            }
        }
    }
}

// MARK: - Transaction Row

private struct TransactionRow: View {
    let tx: PaymentsView.Transaction

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            ZStack {
                if !tx.isSystemIcon {
                    Image(tx.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                } else {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(tx.iconColor.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: tx.icon)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(tx.iconColor)
                }
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(tx.merchant)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Text(tx.date)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.4))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text(String(format: "%@%.2f €", tx.isIncome ? "+" : "−", abs(tx.amount)))
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(tx.isIncome ? Color.theme.success : .white)
                    .monospacedDigit()
                Text(tx.category)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
        }
        .padding(.vertical, 14)
    }
}

// MARK: - Stat Pill

private struct StatPill: View {
    let label: String
    let value: Double
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color.opacity(0.25))
                .frame(width: 6, height: 6)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.45))
                Text(String(format: "%.2f €", value))
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(color.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.sm, style: .continuous)
                .stroke(color.opacity(0.14), lineWidth: 1)
        )
    }
}
