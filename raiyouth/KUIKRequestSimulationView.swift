import SwiftUI
import AudioToolbox

struct KUIKRequestSimulationView: View {
    @Binding var kuikSimulatedReceivedAmount: Double
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    enum SimStep {
        case selectDetails
        case sending
        case waitingForApproval
        case approved
    }

    @State private var currentStep: SimStep = .selectDetails
    @State private var selectedContact = "Dad"
    @State private var selectedAmount = 20.0
    @State private var customContactName = ""
    @State private var customAmount = ""
    @State private var showNotificationBanner = false

    let contacts = [
        ("Dad", "D"),
        ("Mum", "M"),
        ("Alice", "A"),
        ("Bob", "B")
    ]

    let presetAmounts = [10.0, 20.0, 50.0, 100.0]

    var displayContact: String {
        if !customContactName.trimmingCharacters(in: .whitespaces).isEmpty {
            return customContactName
        }
        return selectedContact
    }

    var displayAmount: Double {
        if let val = Double(customAmount), val > 0 {
            return val
        }
        return selectedAmount
    }

    var body: some View {
        ZStack {
            // App Canvas background
            Color.theme.canvas.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("KUIK Request Sim").font(.system(size: 15, weight: .bold)).foregroundColor(.white.opacity(0.6))
                    Spacer()
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color.theme.textSecondary)
                    }
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.top, Theme.Spacing.md)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: Theme.Spacing.xl) {
                        
                        // Zog Guide Area
                        zogGuideHeader
                            .padding(.top, Theme.Spacing.md)

                        switch currentStep {
                        case .selectDetails:
                            selectDetailsView
                        case .sending:
                            sendingView
                        case .waitingForApproval:
                            waitingView
                        case .approved:
                            approvedView
                        }
                    }
                    .padding(.bottom, Theme.Spacing.xxl)
                }
            }

            // In-app Notification Banner Simulation
            if showNotificationBanner {
                VStack {
                    notificationBannerView
                        .transition(.move(edge: .top).combined(with: .opacity))
                    Spacer()
                }
                .zIndex(999)
            }
        }
    }

    // MARK: - Views

    private var zogGuideHeader: some View {
        ZogGuideView(
            pose: currentStep == .approved ? .cheer : (currentStep == .sending ? .reassure : .wave),
            speechBubbleText: speechBubbleTextForCurrentState,
            isHeroSize: currentStep == .approved
        )
        .padding(.horizontal, Theme.Spacing.lg)
    }

    private var speechBubbleTextForCurrentState: String {
        switch currentStep {
        case .selectDetails:
            return "low wallet balance? request money instantly from a friend using KUIK!"
        case .sending:
            return "sending your KUIK request to \(displayContact) now..."
        case .waitingForApproval:
            return "request sent! wait a moment for \(displayContact) to approve it."
        case .approved:
            return "awesome! \(displayContact) approved it and sent you the funds."
        }
    }

    private var selectDetailsView: some View {
        VStack(spacing: Theme.Spacing.lg) {
            
            // Choose Contact Panel
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Text("Select contact").font(.system(size: 14, weight: .bold)).foregroundColor(Color.theme.textSecondary)
                
                HStack(spacing: 8) {
                    ForEach(contacts, id: \.0) { name, initial in
                        Button(action: {
                            selectedContact = name
                            customContactName = ""
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }) {
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(selectedContact == name && customContactName.isEmpty ? Color.theme.accentTeal.opacity(0.2) : Color.white.opacity(0.08))
                                        .frame(width: 38, height: 38)
                                    Text(initial)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(selectedContact == name && customContactName.isEmpty ? Color.theme.accentTeal : .white)
                                }
                                Text(name).font(.system(size: 13, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(selectedContact == name && customContactName.isEmpty ? Color.theme.accentTeal.opacity(0.15) : Color.white.opacity(0.04))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(selectedContact == name && customContactName.isEmpty ? Color.theme.accentTeal : Color.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                        .foregroundColor(.white)
                    }
                }

                // Custom Contact input
                HStack {
                    Image(systemName: "person.badge.plus")
                        .foregroundColor(Color.theme.textSecondary)
                    TextField("Or enter nickname...", text: $customContactName)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .autocorrectionDisabled()
                }
                .padding()
                .background(Color.theme.surface3)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.sm)
                        .stroke(customContactName.isEmpty ? Color.white.opacity(0.08) : Color.theme.accentTeal, lineWidth: 1)
                )
            }
            .padding(Theme.Spacing.lg)
            .glassCard(radius: Theme.Radius.lg)

            // Choose Amount Panel
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Text("Amount to request").font(.system(size: 14, weight: .bold)).foregroundColor(Color.theme.textSecondary)
                
                HStack(spacing: 8) {
                    ForEach(presetAmounts, id: \.self) { amount in
                        Button(action: {
                            selectedAmount = amount
                            customAmount = ""
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }) {
                            Text(String(format: "%.0f €", amount))
                                .font(.system(size: 14, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(selectedAmount == amount && customAmount.isEmpty ? Color.theme.accentTeal.opacity(0.15) : Color.white.opacity(0.04))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(selectedAmount == amount && customAmount.isEmpty ? Color.theme.accentTeal : Color.white.opacity(0.1), lineWidth: 1)
                                )
                        }
                        .foregroundColor(.white)
                    }
                }

                // Custom Amount input
                HStack {
                    Text("€").foregroundColor(Color.theme.textSecondary).font(.system(size: 16, weight: .bold))
                    TextField("Or custom amount...", text: $customAmount)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.theme.surface3)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.sm)
                        .stroke(customAmount.isEmpty ? Color.white.opacity(0.08) : Color.theme.accentTeal, lineWidth: 1)
                )
            }
            .padding(Theme.Spacing.lg)
            .glassCard(radius: Theme.Radius.lg)

            // CTA Button
            Button(action: startKUIKRequestSimulation) {
                HStack {
                    Text("Send KUIK request")
                        .font(.system(size: 15, weight: .bold))
                    Spacer()
                    Image(systemName: "paperplane.fill")
                }
                .foregroundColor(Color(hex: "1A1A14"))
                .padding(.horizontal, Theme.Spacing.lg)
                .frame(height: 50)
                .background(Color.theme.accentPrimary)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, Theme.Spacing.lg)
    }

    private var sendingView: some View {
        VStack(spacing: Theme.Spacing.lg) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.theme.accentTeal))
                .scaleEffect(1.5)
                .padding(.top, 40)
            
            Text("Connecting via KUIK protocol...")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.theme.textSecondary)
        }
    }

    private var waitingView: some View {
        VStack(spacing: Theme.Spacing.lg) {
            VStack(spacing: 8) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Color.theme.accentTeal)
                    .rotationEffect(.degrees(reduceMotion ? 0 : 360))
                    .animation(reduceMotion ? .default : .linear(duration: 12).repeatForever(autoreverses: false), value: currentStep)
                
                Text("Waiting for \(displayContact)'s reply...")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Simulating push notification response in a few seconds.")
                    .font(.system(size: 12))
                    .foregroundColor(Color.theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            .padding(.vertical, 32)
            .frame(maxWidth: .infinity)
            .glassCard(radius: Theme.Radius.lg)
        }
        .padding(.horizontal, Theme.Spacing.lg)
    }

    private var approvedView: some View {
        VStack(spacing: Theme.Spacing.xl) {
            VStack(spacing: 12) {
                Text("Simulated Reward Received!")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white)
                    .kerning(1.4)
                    .textCase(.uppercase)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.12))
                    .clipShape(Capsule())

                Text(String(format: "+%.2f €", displayAmount))
                    .font(.system(size: 56, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)

                Text("Successfully added to your travel balance!")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color.theme.textSecondary)
            }
            .padding(.vertical, 24)

            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Back to home")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(hex: "1A1A14"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.theme.accentPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, Theme.Spacing.lg)
    }

    private var notificationBannerView: some View {
        HStack(spacing: 12) {
            Image("rai_idle")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text("KUIK Instant Transfer")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color.theme.accentTeal)
                Text("\(displayContact) approved request and sent you \(String(format: "%.2f €", displayAmount))!")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding()
        .background(Color.theme.surface3.opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.theme.accentTeal.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.4), radius: 16, x: 0, y: 8)
        .padding(.horizontal, Theme.Spacing.lg)
        .padding(.top, 16)
    }

    // MARK: - Actions

    private func startKUIKRequestSimulation() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        withAnimation {
            currentStep = .sending
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                currentStep = .waitingForApproval
            }
            simulateIncomingApproval()
        }
    }

    private func simulateIncomingApproval() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // Trigger simulated push banner and play SMS/Notification sound
            AudioServicesPlaySystemSound(1003)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            
            withAnimation(.spring()) {
                showNotificationBanner = true
            }

            // Update user balance!
            kuikSimulatedReceivedAmount += displayAmount

            // Dismiss notification banner and proceed step
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    showNotificationBanner = false
                    currentStep = .approved
                }
            }
        }
    }
}
