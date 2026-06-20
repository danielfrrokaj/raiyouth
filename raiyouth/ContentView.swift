//
//  ContentView.swift
//  raiyouth
//

import SwiftUI
import Combine

struct ContentView: View {
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted = false
    @AppStorage("userIntent") private var userIntent = ""
    @AppStorage("userPersona") private var userPersona = ""
    @AppStorage("userCardColor") private var userCardColor = "yellow"
    @AppStorage("userFullName") private var userFullName = ""
    @AppStorage("userIdNumber") private var userIdNumber = ""

    @State private var activeTab = 0
    @State private var showingRewardConfetti = false
    @State private var showResetAlert = false
    @State private var isIntroPlaying = true
    @State private var selectedQuestId: String? = nil
    @State private var isCardExpanded = false
    @State private var showPointsHistory = false
    @State private var showAddMoneySheet = false
    @State private var showCustomizeSheet = false
    @State private var showReportsView = false
    @State private var showAccountDetailsSheet = false
    @State private var showPaymentOptionsSheet = false
    @State private var highlightedMissionId: String? = nil
    @State private var selectedAccountIndex = 0
    @AppStorage("userSignupRewardAmount") private var userSignupRewardAmount = 0.0
    @AppStorage("accountTheme0") private var accountTheme0 = "yellow"
    @AppStorage("accountTheme1") private var accountTheme1 = "dark"

    private var currentAccountTheme: String {
        selectedAccountIndex == 0 ? accountTheme0 : accountTheme1
    }

    @ViewBuilder
    private func themeBackground(_ theme: String, geo: GeometryProxy) -> some View {
        Group {
            switch theme {
            case "yellow":
                Image("background_behind_wallet")
                    .resizable()
                    .scaledToFill()
                    .overlay(
                        LinearGradient(colors: [Color(hex: "FFD21E").opacity(0.35), Color.clear], startPoint: .top, endPoint: .bottom)
                    )
            case "blue":
                LinearGradient(
                    colors: [Color(hex: "0D4F5C"), Color(hex: "2C7A87"), Color.theme.canvas],
                    startPoint: .top, endPoint: .bottom
                )
            case "purple":
                LinearGradient(
                    colors: [Color(hex: "3F1B5C"), Color(hex: "6A3093"), Color.theme.canvas],
                    startPoint: .top, endPoint: .bottom
                )
            case "green":
                LinearGradient(
                    colors: [Color(hex: "084F45"), Color(hex: "11998e"), Color.theme.canvas],
                    startPoint: .top, endPoint: .bottom
                )
            case "crimson":
                LinearGradient(
                    colors: [Color(hex: "6B1114"), Color(hex: "E52D27"), Color.theme.canvas],
                    startPoint: .top, endPoint: .bottom
                )
            case "gray":
                LinearGradient(
                    colors: [Color(hex: "2A2D32"), Color(hex: "34373E"), Color.theme.canvas],
                    startPoint: .top, endPoint: .bottom
                )
            default:
                LinearGradient(
                    colors: [Color(hex: "1A1A14"), Color.theme.canvas],
                    startPoint: .top, endPoint: .bottom
                )
            }
        }
        .frame(width: geo.size.width, height: 380)
    }

    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @Namespace private var tabNamespace

    var body: some View {
        ZStack {
            if isIntroPlaying {
                VideoIntroView(videoName: "intro") {
                    withAnimation(.easeOut(duration: 0.5)) { isIntroPlaying = false }
                }
                .ignoresSafeArea()
                .transition(.opacity)
                .zIndex(100)
            } else {
                if !isOnboardingCompleted {
                    OnboardingContainerView { data in
                        userIntent = data.intent ?? ""
                        userPersona = data.persona ?? ""
                        userCardColor = data.cardColor
                        userFullName = data.fullName
                        userIdNumber = data.idNumber
                        userSignupRewardAmount = data.signupRewardAmount
                        withAnimation(.spring(response: Theme.Motion.screenTransition, dampingFraction: 0.8)) {
                            isOnboardingCompleted = true
                        }
                    }
                    .transition(.opacity)
                } else {
                    NavigationStack {
                        ZStack(alignment: .bottom) {
                            if activeTab == 0 {
                                GeometryReader { geo in
                                    VStack {
                                        ZStack {
                                            // Account 0 background — driven by accountTheme0
                                            themeBackground(accountTheme0, geo: geo)
                                                .opacity(selectedAccountIndex == 0 ? 1 : 0)
                                                .animation(.easeInOut(duration: 0.5), value: accountTheme0)

                                            // Account 1 background — driven by accountTheme1
                                            themeBackground(accountTheme1, geo: geo)
                                                .opacity(selectedAccountIndex == 1 ? 1 : 0)
                                                .animation(.easeInOut(duration: 0.5), value: accountTheme1)
                                        }
                                        .animation(.easeInOut(duration: 0.6), value: selectedAccountIndex)
                                        .clipped()
                                        .mask(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.black, .black.opacity(0.85), .clear]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        Spacer()
                                    }
                                }
                                .ignoresSafeArea()
                            }
    
                            ZStack(alignment: .top) {
                                Group {
                                    switch activeTab {
                                    case 0:
                                        HomeTabView(
                                            userIntent: userIntent,
                                            userPersona: userPersona,
                                            userCardColor: userCardColor,
                                            userFullName: userFullName,
                                            userSignupRewardAmount: userSignupRewardAmount,
                                            selectedQuestId: $selectedQuestId,
                                            isCardExpanded: $isCardExpanded,
                                            showAddMoneySheet: $showAddMoneySheet,
                                            showPointsHistory: $showPointsHistory,
                                            showCustomizeSheet: $showCustomizeSheet,
                                            showReportsView: $showReportsView,
                                            showAccountDetailsSheet: $showAccountDetailsSheet,
                                            showPaymentOptionsSheet: $showPaymentOptionsSheet,
                                            highlightedMissionId: $highlightedMissionId,
                                            selectedAccountIndex: $selectedAccountIndex,
                                            activeTab: $activeTab
                                        )
                                    case 1: PaymentsView()
                                    case 2: MessagesView()
                                    case 3: RaiPointsView(userSignupRewardAmount: userSignupRewardAmount)
                                    default: EmptyView()
                                    }
                                }
    
                                if activeTab == 0 {
                                    HomeHeaderView(
                                        userFullName: userFullName,
                                        userSignupRewardAmount: userSignupRewardAmount,
                                        showPointsHistory: $showPointsHistory,
                                        showResetAlert: $showResetAlert
                                    )
                                }
                            }
    
                            BottomNavBar(
                                activeTab: $activeTab,
                                reduceTransparency: reduceTransparency,
                                namespace: tabNamespace
                            )
                        }
                        .background(Color.theme.canvas.ignoresSafeArea())
                        .sheet(isPresented: $showAddMoneySheet) {
                            AddMoneySheetView()
                        }
                        .sheet(isPresented: $showPointsHistory) {
                        PointsHistoryView(totalPoints: Int(300 + userSignupRewardAmount), highlightedMissionId: highlightedMissionId)
                            .presentationDetents([.large])
                            .presentationDragIndicator(.hidden)
                            .presentationCornerRadius(28)
                            .onDisappear {
                                highlightedMissionId = nil
                            }
                    }
                    .sheet(isPresented: $showCustomizeSheet) {
                        CustomizeAccountSheetView(
                            theme: selectedAccountIndex == 0 ? $accountTheme0 : $accountTheme1
                        )
                            .presentationDetents([.large])
                            .presentationDragIndicator(.hidden)
                            .presentationCornerRadius(28)
                    }
                    .sheet(isPresented: $showAccountDetailsSheet) {
                        AccountDetailsSheetView()
                            .presentationDetents([.medium, .large])
                            .presentationDragIndicator(.hidden)
                            .presentationCornerRadius(28)
                    }
                    .sheet(isPresented: $showPaymentOptionsSheet) {
                        PaymentOptionsSheetView()
                            .presentationDetents([.medium])
                            .presentationDragIndicator(.hidden)
                            .presentationCornerRadius(28)
                    }
                    .fullScreenCover(isPresented: $showReportsView) {
                        ReportsView()
                    }
                    .alert(isPresented: $showResetAlert) {
                        Alert(
                            title: Text("Reset onboarding?"),
                            message: Text("This will erase your setup and let you experience the onboarding flow again."),
                            primaryButton: .destructive(Text("Reset")) {
                                withAnimation {
                                    isOnboardingCompleted = false
                                    isIntroPlaying = true
                                    userIntent = ""
                                    userPersona = ""
                                    userCardColor = "yellow"
                                    userFullName = ""
                                    userIdNumber = ""
                                    userSignupRewardAmount = 0.0
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
        }
    }
}
}

// MARK: - HomeTabView

struct HomeTabView: View {
    let userIntent: String
    let userPersona: String
    let userCardColor: String
    let userFullName: String
    let userSignupRewardAmount: Double
    @Binding var selectedQuestId: String?
    @Binding var isCardExpanded: Bool
    @Binding var showAddMoneySheet: Bool
    @Binding var showPointsHistory: Bool
    @Binding var showCustomizeSheet: Bool
    @Binding var showReportsView: Bool
    @Binding var showAccountDetailsSheet: Bool
    @Binding var showPaymentOptionsSheet: Bool
    @Binding var highlightedMissionId: String?
    @Binding var selectedAccountIndex: Int
    @Binding var activeTab: Int

    @AppStorage("accountTheme0") private var accountTheme0 = "yellow"
    @AppStorage("accountTheme1") private var accountTheme1 = "dark"

    private var accountTheme: String {
        selectedAccountIndex == 0 ? accountTheme0 : accountTheme1
    }

    private var accountThemeColor: Color {
        switch accountTheme {
        case "yellow": return Color.theme.accentPrimary
        case "blue": return Color(hex: "2C7A87")
        case "purple": return Color(hex: "6A3093")
        case "green": return Color(hex: "11998e")
        case "crimson": return Color(hex: "E52D27")
        case "gray": return Color.theme.surface2
        default: return Color.clear
        }
    }

    private var accountTextColor: Color {
        if selectedAccountIndex == 0 {
            switch accountTheme {
            case "yellow": return Color(hex: "1A1A14")
            default: return .white
            }
        }
        return .white
    }
    
    private var totalBalance: Double { 120.0 + userSignupRewardAmount }

    private var accountSecondaryTextColor: Color {
        if selectedAccountIndex == 0 {
            switch accountTheme {
            case "yellow": return Color(hex: "1A1A14").opacity(0.6)
            default: return Color.theme.textSecondary
            }
        }
        return Color.theme.textSecondary
    }

    @ViewBuilder
    private var accountCardBackground: some View {
        if selectedAccountIndex == 0 {
            switch accountTheme {
            case "dark":
                ZStack {
                    Color.black.opacity(0.55)
                    Color.white.opacity(0.04)
                }
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
                ZStack {
                    Color.black.opacity(0.55)
                    Color.white.opacity(0.04)
                }
            }
        } else {
            ZStack {
                Color.black.opacity(0.55)
                Color.white.opacity(0.04)
            }
        }
    }
    
    @ViewBuilder
    private var accountCardBorder: some View {
        if selectedAccountIndex == 0 && accountTheme != "dark" {
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        } else {
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
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
        }
    }

    private var goalTitle: String {
        switch userIntent {
        case "save money": return "emergency fund"
        case "spend wisely": return "weekly food budget"
        case "learn investing": return "my first stock bundle"
        default: return "general savings"
        }
    }
    private var goalTarget: Double {
        switch userIntent {
        case "save money": return 1500.0
        case "spend wisely": return 120.0
        case "learn investing": return 500.0
        default: return 1000.0
        }
    }
    private var goalCurrent: Double {
        switch userIntent {
        case "save money": return 450.0
        case "spend wisely": return 45.0
        case "learn investing": return 150.0
        default: return 200.0
        }
    }

    struct HomeTransaction: Identifiable {
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

    private let transactions: [HomeTransaction] = [
        HomeTransaction(merchant: "Mon Cheri",             date: "Today, 10:15 AM", category: "Food",          amount: -4.50,  isIncome: false, isSystemIcon: false, icon: "moncheri", iconColor: .clear),
        HomeTransaction(merchant: "App Store",             date: "Today, 8:02 AM",  category: "Entertainment", amount: -9.99,  isIncome: false, isSystemIcon: false, icon: "appstore", iconColor: .clear),
        HomeTransaction(merchant: "Received from Dad",     date: "June 18",         category: "Transfer",      amount: 50.00,  isIncome: true,  icon: "arrow.down.left.circle.fill",    iconColor: Color(hex: "3DD68C")),
        HomeTransaction(merchant: "Spotify Premium",       date: "June 15",         category: "Entertainment", amount: -5.99,  isIncome: false, isSystemIcon: false, icon: "spotify", iconColor: .clear)
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: Theme.Spacing.xxl) {
                Spacer().frame(height: 110)
                balanceSection
                addMoneyBanner
                CardSectionView(
                    userPersona: userPersona,
                    userCardColor: userCardColor,
                    userFullName: userFullName,
                    isCardExpanded: $isCardExpanded
                )
                transactionsContainer
                promotionsCarousel
                homeWidgetsSection
                actionButtonsSection
            }
        }
        .mask(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .clear, location: 0),
                    .init(color: .clear, location: 0.08),
                    .init(color: .black, location: 0.16),
                    .init(color: .black, location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    @ViewBuilder private var transactionsContainer: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Text("Recent transactions")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    activeTab = 1 // Switch to Payments tab
                }) {
                    Text("See all")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color.theme.accentPrimary)
                }
            }
            
            VStack(spacing: 0) {
                ForEach(Array(transactions.enumerated()), id: \.element.id) { idx, tx in
                    HStack(spacing: Theme.Spacing.md) {
                        ZStack {
                            if !tx.isSystemIcon {
                                Image(tx.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 42, height: 42)
                                    .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                            } else {
                                RoundedRectangle(cornerRadius: 11, style: .continuous)
                                    .fill(tx.iconColor.opacity(0.15))
                                    .frame(width: 42, height: 42)
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

                        Text(String(format: "%@%.2f €", tx.isIncome ? "+" : "−", abs(tx.amount)))
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(tx.isIncome ? Color.theme.success : .white)
                            .monospacedDigit()
                    }
                    .padding(.vertical, 11)
                    
                    if idx < transactions.count - 1 {
                        Rectangle()
                            .fill(Color.white.opacity(0.06))
                            .frame(height: 1)
                            .padding(.leading, 52)
                    }
                }
            }
        }
        .padding(Theme.Spacing.lg)
        .glassCard(radius: Theme.Radius.lg)
        .padding(.horizontal, Theme.Spacing.lg)
    }

    @ViewBuilder private var balanceSection: some View {
        VStack(spacing: Theme.Spacing.lg) {
            ZStack {
                // ALL Account
                VStack(spacing: Theme.Spacing.xs) {
                    Text("Wallet balance").themeFont(.caption).foregroundColor(.white.opacity(0.8))
                    Text(String(format: "%.2f ALL", totalBalance * 100))
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .monospacedDigit()
                        .tracking(-0.5)
                    Text("Primary account").themeFont(.micro).foregroundColor(.white.opacity(0.6))
                }
                .opacity(selectedAccountIndex == 0 ? 1 : 0)
                .offset(x: selectedAccountIndex == 0 ? 0 : -20)
                
                // EUR Account
                VStack(spacing: Theme.Spacing.xs) {
                    Text("Travel balance").themeFont(.caption).foregroundColor(.white.opacity(0.8))
                    Text(String(format: "%.2f €", totalBalance))
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .monospacedDigit()
                        .tracking(-0.5)
                    Text("Because you're abroad, I set euro.").themeFont(.micro).foregroundColor(.white.opacity(0.6))
                }
                .opacity(selectedAccountIndex == 1 ? 1 : 0)
                .offset(x: selectedAccountIndex == 1 ? 0 : 20)
            }
            .frame(height: 100)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < -30 {
                            // swiped left -> go to next
                            withAnimation(.easeInOut(duration: 0.5)) {
                                selectedAccountIndex = 1
                            }
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        } else if value.translation.width > 30 {
                            // swiped right -> go to previous
                            withAnimation(.easeInOut(duration: 0.5)) {
                                selectedAccountIndex = 0
                            }
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    }
            )
            
            HStack(spacing: 8) {
                Circle()
                    .fill(selectedAccountIndex == 0 ? Color.theme.accentPrimary : Color.white.opacity(0.3))
                    .frame(width: 6, height: 6)
                Circle()
                    .fill(selectedAccountIndex == 1 ? Color.theme.accentPrimary : Color.white.opacity(0.3))
                    .frame(width: 6, height: 6)
            }
            .padding(.top, -8)
            HStack(spacing: Theme.Spacing.xl) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    showAddMoneySheet = true
                }) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle().fill(Color.theme.accentPrimary).frame(width: 48, height: 48)
                            Image(systemName: "plus").font(.system(size: 18, weight: .bold)).foregroundColor(Color(hex: "1A1A14"))
                        }
                        Text("Add money").font(.system(size: 12, weight: .medium)).foregroundColor(.white)
                    }
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    showPaymentOptionsSheet = true
                }) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle().fill(Color.theme.accentPrimary).frame(width: 48, height: 48)
                            Image(systemName: "arrow.left.arrow.right").font(.system(size: 16, weight: .bold)).foregroundColor(Color(hex: "1A1A14"))
                        }
                        Text("Payment").font(.system(size: 12, weight: .medium)).foregroundColor(.white)
                    }
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    showAccountDetailsSheet = true
                }) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle().fill(Color.white).frame(width: 48, height: 48)
                            Image(systemName: "list.bullet.rectangle.fill").font(.system(size: 18, weight: .bold)).foregroundColor(Color(hex: "1A1A14"))
                        }
                        Text("Account").font(.system(size: 12, weight: .medium)).foregroundColor(.white)
                    }
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    showCustomizeSheet = true
                }) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle().fill(Color.white).frame(width: 48, height: 48)
                            Image(systemName: "paintbrush.fill").font(.system(size: 16, weight: .bold)).foregroundColor(Color(hex: "1A1A14"))
                        }
                        Text("Customize").font(.system(size: 12, weight: .medium)).foregroundColor(.white)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.top, Theme.Spacing.xs)
        }
    }

    @ViewBuilder private var addMoneyBanner: some View {
        ZStack(alignment: .bottomLeading) {
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                showAddMoneySheet = true
            }) {
                HStack(spacing: 12) {
                    Spacer().frame(width: 155)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Get your 20 Euros!")
                            .font(.system(size: 16, weight: .bold, design: .rounded)).foregroundColor(.white)
                        Text("Claim your reward by adding money to your account.")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Color.theme.textSecondary)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                    Image(systemName: "chevron.right").font(.system(size: 14, weight: .bold)).foregroundColor(Color.theme.accentPrimary)
                }
                .padding(Theme.Spacing.md)
                .background(LinearGradient(colors: [Color.theme.surface2, Color.theme.surface3], startPoint: .topLeading, endPoint: .bottomTrailing))
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                        .stroke(LinearGradient(colors: [Color.theme.accentPrimary.opacity(0.5), Color.clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                )
                .shadow(color: Color.theme.accentPrimary.opacity(0.15), radius: 12, x: 0, y: 6)
            }
            .buttonStyle(PlainButtonStyle())

            Image("rai_gift_character")
                .resizable()
                .scaledToFit()
                .frame(width: 210)
                .offset(x: -6, y: 0)
                .allowsHitTesting(false)
        }
        .padding(.horizontal, Theme.Spacing.lg)
    }

    @ViewBuilder private var goalProgressSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Text("Active goal").themeFont(.h2).foregroundColor(.white)
                Spacer()
                Text("\(Int((goalCurrent / goalTarget) * 100))% done").themeFont(.micro).foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(goalTitle.sentenceCased).themeFont(.title).foregroundColor(.white)
                Text("\(Int(goalCurrent)) € of \(Int(goalTarget)) € saved").themeFont(.caption).foregroundColor(.white)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.theme.surface3).frame(height: 8)
                    Capsule().fill(Color.theme.accentTeal).frame(width: geo.size.width * CGFloat(goalCurrent / goalTarget), height: 8)
                }
            }
            .frame(height: 8)
            HStack(spacing: Theme.Spacing.md) {
                Image(systemName: "checkmark.circle.fill").foregroundColor(.theme.accentTeal).font(.system(size: 14))
                Text("Start savings").themeFont(.micro).foregroundColor(.white)
                Spacer()
                Circle().fill(Color.theme.accentPrimary).frame(width: 6, height: 6)
                Text("Deposit 100 €").themeFont(.micro).foregroundColor(.white)
                Spacer()
                Image(systemName: "lock.fill").foregroundColor(.white.opacity(0.6)).font(.system(size: 10))
                Text("Earn reward").themeFont(.micro).foregroundColor(.white.opacity(0.6))
            }
            .padding(.top, Theme.Spacing.xs)
        }
        .padding(Theme.Spacing.lg)
        .glassCard(radius: Theme.Radius.lg)
        .padding(.horizontal, Theme.Spacing.lg)
    }

    @ViewBuilder private var questsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Rai quests").themeFont(.h2).foregroundColor(.white)
                    Text("Complete to earn cashback & points").themeFont(.micro).foregroundColor(.white.opacity(0.8))
                }
                Spacer()
                Image("rai_idle").resizable().scaledToFit().frame(width: 44, height: 44)
            }
            VStack(spacing: Theme.Spacing.sm) {
                Button(action: {
                    withAnimation(.spring(response: 0.22, dampingFraction: 0.8)) {
                        selectedQuestId = (selectedQuestId == "coffee" ? nil : "coffee")
                    }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: "cup.and.saucer.fill").foregroundColor(.theme.accentPrimary)
                                Text("Coffee buster quest").themeFont(.title).foregroundColor(.white)
                            }
                            Text("Save 15 € by skipping takeaway coffee.")
                                .themeFont(.caption).foregroundColor(.white.opacity(0.8)).multilineTextAlignment(.leading)
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(Color.theme.surface3).frame(height: 6)
                                    Capsule().fill(Color.theme.accentTeal).frame(width: geo.size.width * 0.66, height: 6)
                                }
                            }
                            .frame(height: 6).padding(.top, 4)
                        }
                        Spacer()
                        VStack {
                            Text("+50 pts").themeFont(.micro).foregroundColor(.theme.accentPrimary)
                            Text("2/3 done").themeFont(.micro).foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(Theme.Spacing.md)
                    .background(selectedQuestId == "coffee" ? Color.theme.accentPrimary.opacity(0.06) : Color.white.opacity(0.01))
                    .cornerRadius(Theme.Radius.md)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.md)
                            .stroke(selectedQuestId == "coffee" ? Color.theme.accentPrimary.opacity(0.4) : Color.theme.glassBorder, lineWidth: 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())

                if selectedQuestId == "coffee" {
                    ZogTipBubble(text: "Skipping 3 coffees a week saves you 15 €! I moved it to your savings pocket.")
                        .transition(.scale.combined(with: .opacity))
                }

                Button(action: {
                    withAnimation(.spring(response: 0.22, dampingFraction: 0.8)) {
                        selectedQuestId = (selectedQuestId == "roundup" ? nil : "roundup")
                    }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: "plus.forwardslash.minus").foregroundColor(.theme.accentTeal)
                                Text("Round-up vault quest").themeFont(.title).foregroundColor(.white)
                            }
                            Text("Save spare change automatically on every purchase.")
                                .themeFont(.caption).foregroundColor(.white.opacity(0.8)).multilineTextAlignment(.leading)
                        }
                        Spacer()
                        VStack {
                            Text("+150 pts").themeFont(.micro).foregroundColor(.theme.accentTeal)
                            Text("active").themeFont(.micro).foregroundColor(.white)
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Color.theme.accentTeal.opacity(0.3))
                                .cornerRadius(Theme.Radius.pill)
                        }
                    }
                    .padding(Theme.Spacing.md)
                    .background(selectedQuestId == "roundup" ? Color.theme.accentTeal.opacity(0.06) : Color.white.opacity(0.01))
                    .cornerRadius(Theme.Radius.md)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.md)
                            .stroke(selectedQuestId == "roundup" ? Color.theme.accentTeal.opacity(0.4) : Color.theme.glassBorder, lineWidth: 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())

                if selectedQuestId == "roundup" {
                    ZogTipBubble(text: "Auto-vaulting spare change saves an average of 45 € a month! You won't even feel it.")
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .padding(Theme.Spacing.lg)
        .glassCard(radius: Theme.Radius.lg)
        .padding(.horizontal, Theme.Spacing.lg)
    }

    @ViewBuilder private var actionButtonsSection: some View {
        HStack(spacing: Theme.Spacing.xl) {
            Button(action: { UINotificationFeedbackGenerator().notificationOccurred(.success) }) {
                VStack(spacing: 8) {
                    ZStack {
                        Circle().fill(.ultraThinMaterial).frame(width: 56, height: 56)
                            .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                        Image(systemName: "paperplane.fill").font(.system(size: 20, weight: .semibold)).foregroundColor(.white)
                    }
                    Text("KUIK send").font(.system(size: 12, weight: .medium)).foregroundColor(.white)
                }
            }
            .buttonStyle(PlainButtonStyle())

            Button(action: { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }) {
                VStack(spacing: 8) {
                    ZStack {
                        Circle().fill(.ultraThinMaterial).frame(width: 56, height: 56)
                            .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                        Image(systemName: "plus").font(.system(size: 22, weight: .semibold)).foregroundColor(.white)
                    }
                    Text("Top up").font(.system(size: 12, weight: .medium)).foregroundColor(.white)
                }
            }
            .buttonStyle(PlainButtonStyle())

            Button(action: {}) {
                VStack(spacing: 8) {
                    ZStack {
                        Circle().fill(.ultraThinMaterial).frame(width: 56, height: 56)
                            .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                        Image(systemName: "list.bullet.rectangle").font(.system(size: 18, weight: .semibold)).foregroundColor(.white)
                    }
                    Text("Transactions").font(.system(size: 12, weight: .medium)).foregroundColor(.white)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, Theme.Spacing.lg)
        .padding(.bottom, 110)
    }

    @ViewBuilder private var promotionsCarousel: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Text("For You").themeFont(.h2).foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    let promoCards = [
                        "card-invite-friend",
                        "card-order-debid-card",
                        "card-wolt-orders",
                        "apple-pay"
                    ]
                    
                    ForEach(promoCards, id: \.self) { cardImage in
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            if cardImage == "card-invite-friend" { highlightedMissionId = "invite" }
                            else if cardImage == "card-order-debid-card" { highlightedMissionId = "card" }
                            else if cardImage == "card-wolt-orders" { highlightedMissionId = "purchase" }
                            showPointsHistory = true
                        }) {
                            Image(cardImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width * 0.7, height: 160)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.bottom, 8)
            }
        }
    }

    @ViewBuilder private var homeWidgetsSection: some View {
        VStack(spacing: Theme.Spacing.md) {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    showReportsView = true
                }) {
                    HStack {
                        Text("Total wealth").font(.system(size: 14, weight: .medium)).foregroundColor(Color.theme.textSecondary)
                        Image(systemName: "chevron.right").font(.system(size: 12, weight: .bold)).foregroundColor(Color.theme.textSecondary)
                        Spacer()
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Text(selectedAccountIndex == 0
                     ? String(format: "%.2f ALL", totalBalance * 100)
                     : String(format: "%.2f €", totalBalance))
                    .font(.system(size: 32, weight: .bold, design: .rounded)).foregroundColor(.white)
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        Circle().fill(Color.theme.accentPrimary).frame(width: 36, height: 36)
                            .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                            .overlay(Image(systemName: "banknote.fill").foregroundColor(.white).font(.system(size: 14)))
                        Text("Cash").font(.system(size: 16, weight: .medium)).foregroundColor(.white)
                        Spacer()
                        Text(selectedAccountIndex == 0
                             ? String(format: "%.2f ALL", totalBalance * 100)
                             : String(format: "%.2f €", totalBalance))
                            .font(.system(size: 16, weight: .regular)).foregroundColor(.white)
                    }
                    HStack(spacing: 16) {
                        Circle().fill(Color.theme.accentPrimary).frame(width: 36, height: 36)
                            .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                            .overlay(Image(systemName: "chart.pie.fill").foregroundColor(.white).font(.system(size: 14)))
                        Text("Savings & Funds").font(.system(size: 16, weight: .medium)).foregroundColor(.white)
                        Spacer()
                        Text("0 ALL").font(.system(size: 16, weight: .regular)).foregroundColor(.white)
                    }
                    HStack(spacing: 16) {
                        Circle().fill(Color.theme.accentPrimary).frame(width: 36, height: 36)
                            .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                            .overlay(Image(systemName: "chart.bar.fill").foregroundColor(.white).font(.system(size: 14)))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Invest").font(.system(size: 16, weight: .medium)).foregroundColor(.white)
                            Text("Invest for as little as 1 ALL").font(.system(size: 12, weight: .regular)).foregroundColor(Color.theme.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right").font(.system(size: 14, weight: .medium)).foregroundColor(Color.theme.textSecondary)
                    }
                    HStack(spacing: 16) {
                        Circle().fill(Color.theme.accentPrimary).frame(width: 36, height: 36)
                            .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                            .overlay(Image(systemName: "link").foregroundColor(.white).font(.system(size: 14)))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Linked").font(.system(size: 16, weight: .medium)).foregroundColor(.white)
                            Text("Link external accounts").font(.system(size: 12, weight: .regular)).foregroundColor(Color.theme.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right").font(.system(size: 14, weight: .medium)).foregroundColor(Color.theme.textSecondary)
                    }
                }
                .padding(.top, 8)
            }
            .padding(Theme.Spacing.lg)
            .background(Color.theme.surface2)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous).strokeBorder(Color.theme.glassBorder, lineWidth: 1))

            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                Text("Spent this month").font(.system(size: 14, weight: .medium)).foregroundColor(Color.theme.textSecondary)
                HStack(alignment: .bottom) {
                    Text("0 ALL").font(.system(size: 28, weight: .bold, design: .rounded)).foregroundColor(.white)
                    Spacer()
                    Text("0 ALL").font(.system(size: 12, weight: .regular)).foregroundColor(Color.theme.textSecondary).padding(.bottom, 6)
                }
                HStack(alignment: .bottom, spacing: 4) {
                    ForEach(0..<15) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(index < 8 ? Color.theme.textSecondary.opacity(0.3) : Color.clear)
                            .frame(height: index == 7 ? 24 : (index < 7 ? CGFloat.random(in: 4...16) : 24))
                    }
                }
                .frame(height: 30).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 16)
            }
            .padding(Theme.Spacing.lg)
            .background(Color.theme.surface2)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous).strokeBorder(Color.theme.glassBorder, lineWidth: 1))
        }
        .padding(.horizontal, Theme.Spacing.lg)
        .padding(.top, Theme.Spacing.md)
    }
}

// MARK: - CardSectionView

struct CardSectionView: View {
    let userPersona: String
    let userCardColor: String
    let userFullName: String
    @Binding var isCardExpanded: Bool

    var body: some View {
        let color = OnboardingCardCustomizationView.CardColor(rawValue: userCardColor) ?? .yellow
        let cardWidth = UIScreen.main.bounds.width * 2 / 3
        let cardHeight = cardWidth * 0.63
        let expandedWidth = UIScreen.main.bounds.width - Theme.Spacing.lg * 2

        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Text("Your card").themeFont(.h2).foregroundColor(.white)
                Spacer()
                Text(userPersona.sentenceCased)
                    .themeFont(.micro).foregroundColor(.white)
                    .padding(.horizontal, Theme.Spacing.sm).padding(.vertical, 4)
                    .background(Color.theme.accentPrimary.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.pill, style: .continuous))
            }
            .padding(.horizontal, Theme.Spacing.lg)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    cardVisual(color: color, width: isCardExpanded ? expandedWidth : cardWidth, height: isCardExpanded ? expandedWidth * 0.63 : cardHeight)

                    if !isCardExpanded {
                        Button(action: { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }) {
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle().fill(.ultraThinMaterial).frame(width: 44, height: 44)
                                        .overlay(Circle().stroke(Color.white.opacity(0.25), lineWidth: 1))
                                    Image(systemName: "plus").font(.system(size: 18, weight: .semibold)).foregroundColor(.white)
                                }
                                Text("Add card").font(.system(size: 11, weight: .medium, design: .rounded)).foregroundColor(.white.opacity(0.6))
                            }
                            .frame(width: 80, height: cardHeight)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .transition(.opacity.combined(with: .scale))
                    }
                }
                .padding(.horizontal, Theme.Spacing.lg)
            }
            .scrollDisabled(isCardExpanded)

            if isCardExpanded {
                HStack(spacing: Theme.Spacing.md) {
                    Button(action: { UIImpactFeedbackGenerator(style: .rigid).impactOccurred() }) {
                        Label("Freeze card", systemImage: "lock.fill")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity).frame(height: 46)
                    }
                    .buttonStyle(.glass)

                    Button(action: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        UIPasteboard.general.string = "•••• •••• •••• 2026"
                    }) {
                        Label("Copy details", systemImage: "doc.on.doc.fill")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity).frame(height: 46)
                    }
                    .buttonStyle(.glass)
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    @ViewBuilder private func cardVisual(color: OnboardingCardCustomizationView.CardColor, width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            if color == .yellow {
                ZStack {
                    Image("card")
                        .resizable().scaledToFill()
                        .frame(width: width, height: height).clipped()
                        .opacity(isCardExpanded ? 0 : 1)
                        .accessibility(hidden: isCardExpanded)

                    Image("back-of-thedebit-card")
                        .resizable().scaledToFill()
                        .frame(width: width, height: height).clipped()
                        .opacity(isCardExpanded ? 1 : 0)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        .accessibility(hidden: !isCardExpanded)
                }
            } else {
                ZStack {
                    VStack(alignment: .leading) {
                        HStack {
                            (Text("rai").font(.system(size: 12, weight: .semibold, design: .rounded)).italic()
                             + Text("youth").font(.system(size: 12, weight: .regular, design: .rounded)))
                            Spacer()
                            Image(systemName: "wave.3.right").font(.system(size: 9, weight: .semibold)).rotationEffect(.degrees(-90))
                        }
                        .foregroundColor(color.textColor)
                        Spacer()
                        Text("••••  ••••  ••••  2026").font(.system(size: 11, weight: .medium, design: .monospaced)).foregroundColor(color.textColor)
                        Text(userFullName.sentenceCased).font(.system(size: 10, weight: .semibold)).foregroundColor(color.textColor)
                    }
                    .padding(12)
                    .background(color.gradient)
                    .opacity(isCardExpanded ? 0 : 1)
                    
                    Image("back-of-thedebit-card")
                        .resizable().scaledToFill()
                        .frame(width: width, height: height).clipped()
                        .opacity(isCardExpanded ? 1 : 0)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                }
                .frame(width: width, height: height)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(Color.white.opacity(0.15), lineWidth: 1))
        .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
        .rotation3DEffect(.degrees(isCardExpanded ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) { isCardExpanded.toggle() }
        }
    }
}

// MARK: - HomeHeaderView

struct HomeHeaderView: View {
    let userFullName: String
    let userSignupRewardAmount: Double
    @Binding var showPointsHistory: Bool
    @Binding var showResetAlert: Bool

    var body: some View {
        HStack {
            let initials = userFullName.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined().uppercased()
            let displayInitials = initials.isEmpty ? "DF" : initials

            Circle()
                .fill(Color.theme.accentPrimary)
                .frame(width: 38, height: 38)
                .overlay(Text(displayInitials).font(.system(size: 14, weight: .bold, design: .rounded)).foregroundColor(.white))
                .shadow(color: Color.theme.accentPrimary.opacity(0.3), radius: 4)

            VStack(alignment: .leading, spacing: 2) {
                Text(userFullName.sentenceCased).themeFont(.title).foregroundColor(.white)
            }

            Spacer()

            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                showPointsHistory = true
            }) {
                let points = Int(300 + userSignupRewardAmount)
                HStack(spacing: 4) {
                    Image(systemName: "r.circle.fill")
                        .resizable().scaledToFit()
                        .frame(width: 14, height: 14).foregroundColor(.white)
                    Text("Level 2")
                        .font(.system(size: 11, weight: .bold, design: .rounded)).monospacedDigit().foregroundColor(.white)
                }
                .padding(.horizontal, 12).padding(.vertical, 6)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "C98A00"), Color(hex: "A86E00"), Color(hex: "C98A00")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
                .shadow(color: Color(hex: "A86E00").opacity(0.4), radius: 6, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 4)

            Button(action: { showResetAlert = true }) {
                Image(systemName: "arrow.counterclockwise.circle.fill").font(.system(size: 22)).foregroundColor(.white)
            }
        }
        .padding(.top, Theme.Spacing.xl)
        .padding(.horizontal, Theme.Spacing.lg)
        .padding(.bottom, Theme.Spacing.lg)
        .background(Color.clear)
    }
}

// MARK: - BottomNavBar

struct BottomNavBar: View {
    @Binding var activeTab: Int
    let reduceTransparency: Bool
    var namespace: Namespace.ID

    private let icons = ["house.fill", "creditcard.fill", "bubble.left.and.bubble.right.fill", "sparkles"]
    private let labels = ["Home", "Payments", "Kuik", "RaiPoints"]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<4) { index in
                Spacer()
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) { activeTab = index }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }) {
                    VStack(spacing: 4) {
                        if index == 3 {
                            Image(systemName: "r.circle.fill")
                                .resizable().scaledToFit()
                                .frame(width: 19, height: 19)
                        } else {
                            Image(systemName: icons[index])
                                .font(.system(size: 19))
                                .symbolEffect(.bounce, value: activeTab == index)
                        }
                        Text(labels[index]).font(.system(size: 10, weight: .medium))
                    }
                    .foregroundColor(activeTab == index ? .theme.accentPrimary : .theme.textSecondary)
                    .padding(.vertical, 8).padding(.horizontal, 14)
                    .background {
                        if activeTab == index {
                            Capsule()
                                .fill(Color.white.opacity(0.06))
                                .overlay(Capsule().stroke(Color.white.opacity(0.12), lineWidth: 1))
                                .matchedGeometryEffect(id: "activeTab", in: namespace)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
        }
        .padding(.vertical, 8)
        .background(
            Group {
                if reduceTransparency {
                    Color.theme.surface1
                } else {
                    Color.clear.background(.ultraThinMaterial)
                }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.30), Color.white.opacity(0.10), Color.white.opacity(0.04)],
                        startPoint: .top, endPoint: .bottom
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(0.35), radius: 24, x: 0, y: 8)
        .padding(.horizontal, Theme.Spacing.lg)
        .padding(.bottom, Theme.Spacing.lg)
    }
}

// MARK: - AddMoneySheetView

struct AddMoneySheetView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.canvas.edgesIgnoringSafeArea(.all)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: Theme.Spacing.lg) {
                        VStack(spacing: 8) {
                            ZStack {
                                Circle().fill(Color.theme.accentPrimary.opacity(0.15)).frame(width: 64, height: 64)
                                Image(systemName: "plus").font(.system(size: 28, weight: .bold)).foregroundColor(Color.theme.accentPrimary)
                            }
                            Text("Add Money").font(.system(size: 24, weight: .bold, design: .rounded)).foregroundColor(.white)
                            Text("Top up your account to claim your 20€ reward.")
                                .font(.system(size: 14, weight: .regular)).foregroundColor(Color.theme.textSecondary)
                                .multilineTextAlignment(.center).padding(.horizontal, 32)
                        }
                        .padding(.top, Theme.Spacing.xl).padding(.bottom, Theme.Spacing.md)

                        VStack(spacing: Theme.Spacing.md) {
                            AddMoneyOptionRow(icon: "paperplane.fill", iconColor: Color.theme.accentTeal, title: "Ask a friend with KUIK", subtitle: "Send a request via phone number instantly.")
                            AddMoneyOptionRow(icon: "building.columns.fill", iconColor: Color(hex: "5675FF"), title: "Deposit from bank account", subtitle: "Use your IBAN to receive a standard transfer.")
                            AddMoneyOptionRow(icon: "creditcard.fill", iconColor: Color(hex: "FF794B"), title: "Top up with card", subtitle: "Use Apple Pay or another debit/credit card.")
                        }
                        .padding(.horizontal, Theme.Spacing.lg)

                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark.circle.fill").font(.system(size: 24)).foregroundColor(Color.theme.textSecondary)
                    }
                }
            }
        }
    }
}

struct AddMoneyOptionRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String

    var body: some View {
        Button(action: { UIImpactFeedbackGenerator(style: .light).impactOccurred() }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle().fill(iconColor.opacity(0.15)).frame(width: 48, height: 48)
                    Image(systemName: icon).font(.system(size: 20, weight: .medium)).foregroundColor(iconColor)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                    Text(subtitle).font(.system(size: 13, weight: .regular)).foregroundColor(Color.theme.textSecondary).multilineTextAlignment(.leading)
                }
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 14, weight: .bold)).foregroundColor(Color.theme.textSecondary.opacity(0.5))
            }
            .padding(Theme.Spacing.md)
            .background(Color.theme.surface2)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous).stroke(Color.white.opacity(0.08), lineWidth: 1))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Components

struct ZogTipBubble: View {
    let text: String
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image("rai_idle")
                .resizable().scaledToFill()
                .frame(width: 36, height: 36)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("raiyouth")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.55)).textCase(.uppercase)
                    Spacer()
                    Text("now").font(.system(size: 11, weight: .regular)).foregroundColor(.white.opacity(0.4))
                }
                Text(text.sentenceCased)
                    .font(.system(size: 13, weight: .regular)).foregroundColor(.white)
                    .lineLimit(2).fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 14).padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(reduceTransparency ? Color.theme.surface3 : Color.white.opacity(0.12))
                .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.ultraThinMaterial))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        )
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(Color.white.opacity(0.18), lineWidth: 1))
        .shadow(color: Color.black.opacity(0.22), radius: 12, x: 0, y: 4)
    }
}

#Preview {
    ContentView()
}
