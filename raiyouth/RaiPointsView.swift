import SwiftUI

struct RaiPointsView: View {
    let userSignupRewardAmount: Double
    @State private var points = 320
    @State private var selectedProduct: String = "eSIM"
    @State private var redeemedItem: String? = nil
    @State private var coinAnimating = false
    @State private var pendingItem: RewardItem? = nil
    @State private var showConfirmation = false
    
    // Product data matching the catalog selection
    struct RewardItem: Identifiable {
        let id = UUID()
        let title: String
        let cost: Int
        let description: String
        var isSystemIcon: Bool = true
        let icon: String
    }
    
    let eSIMRewards = [
        RewardItem(title: "Global e-SIM 1GB", cost: 150, description: "1 GB high speed data valid for 7 days globally.", icon: "antenna.radiowaves.left.and.right"),
        RewardItem(title: "Europe e-SIM 5GB", cost: 300, description: "5 GB regional data valid for 30 days.", icon: "globe.europe.africa.fill")
    ]
    
    let staysRewards = [
        RewardItem(title: "Luxury Hotel Discount (50 €)", cost: 400, description: "Get 50 € off on stays in Tirana & Europe.", icon: "bed.double.fill"),
        RewardItem(title: "Resort Perk Package", cost: 200, description: "Free breakfast & late checkout at partner stays.", icon: "sun.max.fill")
    ]
    
    let milesRewards = [
        RewardItem(title: "WizzAir Discount", cost: 250, description: "Convert points to 500 airline miles.", isSystemIcon: false, icon: "wizzair"),
        RewardItem(title: "Lounge Pass Albania", cost: 150, description: "Single-entry VIP airport lounge pass.", icon: "star.fill")
    ]
    
    let shopsRewards = [
        RewardItem(title: "Wolt 5 € Delivery", cost: 100, description: "Get 5 € off your next Wolt order.", isSystemIcon: false, icon: "wolt"),
        RewardItem(title: "Adidas 10 € Voucher", cost: 250, description: "10 € digital gift code for Adidas.", isSystemIcon: false, icon: "adidas"),
        RewardItem(title: "Spotify 1 Month Premium", cost: 120, description: "Get 1 month of music streaming free.", isSystemIcon: false, icon: "spotify"),
        RewardItem(title: "Cineplexx 1 Ticket", cost: 100, description: "1 free ticket.", isSystemIcon: false, icon: "cineplexx"),
        RewardItem(title: "GjirafaTravel 5 €", cost: 50, description: "5 € off your next trip.", isSystemIcon: false, icon: "gjirafatravel")
    ]
    
    var currentCatalog: [RewardItem] {
        switch selectedProduct {
        case "Miles": return milesRewards
        case "Stays": return staysRewards
        case "eSIM": return eSIMRewards
        case "Shops": return shopsRewards
        default: return eSIMRewards
        }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: Theme.Spacing.lg) {
                // Top spacer for sticky header overlay clearance
                Spacer().frame(height: 50)
                
                // Main Points Display
                VStack(spacing: Theme.Spacing.xs) {
                    Text("Standard plan")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                    
                    HStack(spacing: 8) {
                        RaiCoinView(size: 44, isAnimating: coinAnimating)

                        Text("\(points)")
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .monospacedDigit()
                    }
                    
                    Text("1 point / 15 € spent ⓘ")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.top, 2)
                    
                    // Upgrade Button
                    Button(action: {}) {
                        Text("Upgrade")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.12))
                            .cornerRadius(18)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, 6)
                }
                .padding(.vertical, Theme.Spacing.md)
                
                // Quick Actions (Earn, Redeem, Perks, More)
                HStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Circle()
                            .fill(Color.white.opacity(0.08))
                            .frame(width: 48, height: 48)
                            .overlay(Image(systemName: "plus").foregroundColor(.white))
                        Text("Earn")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    VStack(spacing: 8) {
                        Circle()
                            .fill(Color.white.opacity(0.08))
                            .frame(width: 48, height: 48)
                            .overlay(Image(systemName: "banknote.fill").foregroundColor(.white))
                        Text("Redeem")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    VStack(spacing: 8) {
                        Circle()
                            .fill(Color.white.opacity(0.08))
                            .frame(width: 48, height: 48)
                            .overlay(Image(systemName: "diamond.fill").foregroundColor(.white))
                        Text("Plan perks")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    VStack(spacing: 8) {
                        Circle()
                            .fill(Color.white.opacity(0.08))
                            .frame(width: 48, height: 48)
                            .overlay(Image(systemName: "ellipsis").foregroundColor(.white))
                        Text("More")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .padding(.vertical, 8)
                
                // Wolt Promo Banner
                HStack(spacing: Theme.Spacing.md) {
                    Image("wolt")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 56, height: 56)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("5x RaiPoints at Wolt")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("When you pay using RaiPay until 18 July. T&Cs apply.")
                            .font(.system(size: 12))
                            .foregroundColor(Color.theme.textSecondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.theme.accentPrimary)
                }
                .padding(Theme.Spacing.md)
                .glassCard(radius: Theme.Radius.lg)
                .padding(.horizontal, Theme.Spacing.lg)
                
                // Products Title
                HStack {
                    Text("Products")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.top, 6)
                
                // Products Grid (Miles, Stays, eSIM, Shops)
                HStack(spacing: 12) {
                    ProductTab(title: "Miles", icon: "airplane", selected: selectedProduct == "Miles") {
                        selectedProduct = "Miles"
                    }
                    ProductTab(title: "Stays", icon: "bed.double.fill", selected: selectedProduct == "Stays") {
                        selectedProduct = "Stays"
                    }
                    ProductTab(title: "eSIM", icon: "personalhotspot", selected: selectedProduct == "eSIM") {
                        selectedProduct = "eSIM"
                    }
                    ProductTab(title: "Shops", icon: "bag.fill", selected: selectedProduct == "Shops") {
                        selectedProduct = "Shops"
                    }
                }
                .padding(.horizontal, Theme.Spacing.lg)
                
                // Active Product Catalog Cards Grid
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                    ForEach(currentCatalog) { item in
                        VStack(alignment: .leading, spacing: 0) {
                            // Card header icon area
                            ZStack {
                                if !item.isSystemIcon {
                                    Image(item.icon)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 90)
                                        .frame(maxWidth: .infinity)
                                        .clipped()
                                } else {
                                    ZStack {
                                        Color.black.opacity(0.15)
                                            .frame(height: 90)
                                        
                                        Circle()
                                            .fill(Color.white.opacity(0.08))
                                            .frame(width: 44, height: 44)
                                        
                                        Image(systemName: item.icon)
                                            .foregroundColor(.white)
                                            .font(.system(size: 18))
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                                Text(item.title)
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                
                                Text(item.description)
                                    .font(.system(size: 11))
                                    .foregroundColor(Color.theme.textSecondary)
                                    .lineLimit(2)
                                    .frame(height: 32, alignment: .topLeading)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.horizontal, Theme.Spacing.md)
                            .padding(.top, Theme.Spacing.md)
                            .padding(.bottom, Theme.Spacing.sm)
                            
                            Spacer(minLength: 0)
                            
                            Button(action: {
                                if points >= item.cost {
                                    pendingItem = item
                                    showConfirmation = true
                                }
                            }) {
                                Text("\(item.cost) RaiPoints")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color.theme.textOnAccentYellow)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 36)
                                    .background(Color.theme.accentPrimary)
                                    .cornerRadius(Theme.Radius.sm)
                            }
                            .disabled(points < item.cost)
                            .opacity(points < item.cost ? 0.35 : 1.0)
                            .padding(.horizontal, Theme.Spacing.md)
                            .padding(.bottom, Theme.Spacing.md)
                        }
                        .background(Color.white.opacity(0.02))
                        .glassCard(radius: Theme.Radius.lg)
                    }
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.bottom, 110)
            }
        }
        .sheet(isPresented: $showConfirmation) {
            if let item = pendingItem {
                RedeemConfirmationSheet(
                    item: item,
                    userPoints: points,
                    onConfirm: {
                        showConfirmation = false
                        points -= item.cost
                        redeemedItem = item.title
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        coinAnimating = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { coinAnimating = false }
                        pendingItem = nil
                    },
                    onCancel: {
                        showConfirmation = false
                        pendingItem = nil
                    }
                )
                .presentationDetents([.height(480)])
                .presentationDragIndicator(.visible)
                .presentationBackground(Color(red: 0.1, green: 0.1, blue: 0.12))
            }
        }
        .alert(item: Binding(
            get: { redeemedItem.map { RedeemedAlert(message: $0) } },
            set: { _ in redeemedItem = nil }
        )) { alert in
            Alert(
                title: Text("Redeemed!"),
                message: Text("You successfully got \(alert.message). Details sent to your account."),
                dismissButton: .default(Text("Perfect"))
            )
        }
    }
}

// Product Selection Tab
struct ProductTab: View {
    let title: String
    let icon: String
    let selected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selected ? Color.white.opacity(0.18) : Color.white.opacity(0.08))
                        .frame(width: 68, height: 60)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selected ? Color.white.opacity(0.3) : Color.clear, lineWidth: 1)
                        )
                    
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                }
                
                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(selected ? .white : .white.opacity(0.6))
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RedeemedAlert: Identifiable {
    let id = UUID()
    let message: String
}

struct RedeemConfirmationSheet: View {
    let item: RaiPointsView.RewardItem
    let userPoints: Int
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Character
            Image("rai_cheer")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding(.top, Theme.Spacing.xl)

            VStack(spacing: Theme.Spacing.sm) {
                Text("Use your RaiPoints?")
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundColor(.white)

                Text("You're about to redeem")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.5))

                Text(item.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.xl)
            }
            .padding(.top, Theme.Spacing.md)

            // Cost breakdown
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Cost")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                    Text("\(item.cost) RaiPoints")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color.theme.accentPrimary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("Remaining after")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                    Text("\(userPoints - item.cost) RaiPoints")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(Theme.Spacing.md)
            .background(Color.white.opacity(0.06))
            .cornerRadius(Theme.Radius.md)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.md)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.lg)

            Spacer()

            // Action buttons
            VStack(spacing: Theme.Spacing.sm) {
                Button(action: onConfirm) {
                    Text("Confirm Redemption")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.theme.textOnAccentYellow)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.theme.accentPrimary)
                        .cornerRadius(Theme.Radius.md)
                }

                Button(action: onCancel) {
                    Text("Cancel")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.xl)
        }
    }
}
