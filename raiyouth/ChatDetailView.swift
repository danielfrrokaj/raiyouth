import SwiftUI

struct ChatDetailView: View {
    let chatName: String
    let isOnline: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    struct Message: Identifiable {
        let id = UUID()
        var text: String?
        var amount: Double?
        var emoji: String?
        var isMe: Bool
        var isTransaction: Bool { amount != nil }
    }
    
    // Initializer to set custom initial messages for Rai
    init(chatName: String, isOnline: Bool) {
        self.chatName = chatName
        self.isOnline = isOnline
        
        if chatName == "Rai" {
            _messages = State(initialValue: [
                Message(text: "hi! i'm Rai, your personal guide. i can help you analyze your spending, guide you through cool features, or note down your feedback. what should we start with?", isMe: false)
            ])
            _quickReplies = State(initialValue: ["analyze transactions 📊", "explore features ✨", "give feedback 💬"])
            _lastQuestionAsked = State(initialValue: .welcome)
        } else {
            _messages = State(initialValue: [
                Message(text: "Hey! Thanks for getting the tickets.", isMe: false),
                Message(text: "No problem!", isMe: true),
                Message(amount: 25.00, emoji: "🎟️", isMe: true)
            ])
            _quickReplies = State(initialValue: [])
            _lastQuestionAsked = State(initialValue: nil)
        }
    }
    
    @State private var messages: [Message]
    @State private var inputText: String = ""
    @State private var showingSendMoneySheet = false
    @State private var sendAmount: String = ""
    @State private var selectedEmoji: String = "💸"
    
    // Simulated chat states
    @State private var isTyping = false
    @State private var quickReplies: [String]
    @State private var lastQuestionAsked: QuestionType?
    
    enum QuestionType {
        case welcome
        case transactions
        case features
        case feedback
        case transactionGoalPrompt
    }
    
    let emojis = ["💸", "🍔", "🚕", "🎟️", "🍻", "☕️"]
    
    var body: some View {
        ZStack {
            Color.theme.canvas.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header
                HStack(spacing: 16) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    ZStack(alignment: .bottomTrailing) {
                        if chatName == "Rai" {
                            RaiAvatar(size: 40)
                                .overlay(Circle().stroke(Color.theme.accentPrimary, lineWidth: 1))
                        } else {
                            let initials = chatName.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined()
                            Circle()
                                .fill(Color.white.opacity(0.12))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text(initials)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                )
                        }
                        
                        if isOnline {
                            Circle()
                                .fill(Color.theme.success)
                                .frame(width: 12, height: 12)
                                .overlay(Circle().stroke(Color.theme.canvas, lineWidth: 2))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text(chatName)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            
                            if chatName == "Rai" {
                                Text("assistant")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(Color.theme.accentPrimary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.theme.accentPrimary.opacity(0.15))
                                    .cornerRadius(4)
                            }
                        }
                        
                        if isOnline {
                            Text("active now")
                                .font(.system(size: 12))
                                .foregroundColor(Color.theme.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.theme.canvas)
                
                // Messages List
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            if chatName == "Rai" {
                                // Highlighted Character header on top
                                VStack(spacing: 12) {
                                    ZStack {
                                        RaiAvatar(size: 90)
                                            .overlay(Circle().stroke(Color.theme.accentPrimary, lineWidth: 2))
                                            .shadow(color: Color.theme.accentPrimary.opacity(0.3), radius: 10)
                                        
                                        Circle()
                                            .fill(Color.theme.success)
                                            .frame(width: 14, height: 14)
                                            .overlay(Circle().stroke(Color.theme.canvas, lineWidth: 2))
                                            .offset(x: 30, y: 30)
                                    }
                                    .padding(.top, 16)
                                    
                                    VStack(spacing: 6) {
                                        HStack(spacing: 6) {
                                            Text("Rai")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.white)
                                            Text("assistant")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(Color.theme.accentPrimary)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color.theme.accentPrimary.opacity(0.15))
                                                .cornerRadius(4)
                                        }
                                        
                                        Text("your personal pocket companion")
                                            .font(.system(size: 13))
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                }
                                .padding(.bottom, 16)
                            }
                            
                            ForEach(messages) { message in
                                MessageBubble(message: message, chatName: chatName)
                                    .id(message.id)
                            }
                            
                            if isTyping {
                                HStack(alignment: .bottom, spacing: 8) {
                                    RaiAvatar(size: 28)
                                        .overlay(Circle().stroke(Color.theme.accentPrimary, lineWidth: 1))
                                    
                                    HStack(spacing: 4) {
                                        Circle()
                                            .fill(Color.white.opacity(0.5))
                                            .frame(width: 6, height: 6)
                                        Circle()
                                            .fill(Color.white.opacity(0.5))
                                            .frame(width: 6, height: 6)
                                        Circle()
                                            .fill(Color.white.opacity(0.5))
                                            .frame(width: 6, height: 6)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.theme.surface2)
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    
                                    Spacer()
                                }
                                .id("typingIndicator")
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages.count) { _ in
                        scrollToBottom(proxy: proxy)
                    }
                    .onChange(of: isTyping) { typing in
                        if typing {
                            withAnimation {
                                proxy.scrollTo("typingIndicator", anchor: .bottom)
                            }
                        } else {
                            scrollToBottom(proxy: proxy)
                        }
                    }
                }
                
                // Quick Replies float above input bar
                if chatName == "Rai" && !quickReplies.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(quickReplies, id: \.self) { reply in
                                Button(action: {
                                    handleUserMessage(reply)
                                }) {
                                    Text(reply)
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(Color.theme.textOnAccentYellow)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(Color.theme.accentPrimary)
                                        .cornerRadius(20)
                                        .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
                                }
                                .buttonStyle(CardButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                    .background(Color.theme.canvas)
                }
                
                // Input Bar
                HStack(spacing: 12) {
                    Button(action: {
                        showingSendMoneySheet = true
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.theme.accentPrimary)
                                .frame(width: 40, height: 40)
                            Image(systemName: "plus.forwardslash.minus")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(hex: "1A1A14"))
                        }
                    }
                    .disabled(chatName == "Rai")
                    .opacity(chatName == "Rai" ? 0.3 : 1.0)
                    
                    HStack {
                        TextField(chatName == "Rai" ? "ask Rai something..." : "message...", text: $inputText)
                            .foregroundColor(.white)
                            .accentColor(Color.theme.accentPrimary)
                        
                        if !inputText.isEmpty {
                            Button(action: {
                                handleUserMessage(inputText)
                            }) {
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(Color.theme.accentPrimary)
                                    .font(.system(size: 18))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 44)
                    .background(Color.theme.surface3)
                    .cornerRadius(Theme.Radius.sm)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.sm)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
                }
                .padding()
                .background(Color.theme.canvas.ignoresSafeArea(.container, edges: .bottom))
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingSendMoneySheet) {
            sendMoneySheet
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastId = messages.last?.id {
            withAnimation {
                proxy.scrollTo(lastId, anchor: .bottom)
            }
        }
    }
    
    private var sendMoneySheet: some View {
        ZStack {
            Color.theme.canvas.ignoresSafeArea()
            VStack(spacing: 24) {
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 40, height: 4)
                    .padding(.top, 12)
                
                Text("send money")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 8) {
                    Text("amount")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                    
                    TextField("0.00", text: $sendAmount)
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                    
                    Text("ALL")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.theme.accentPrimary)
                }
                .padding(.vertical, 20)
                
                VStack(spacing: 12) {
                    Text("add an emoji")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 16) {
                        ForEach(emojis, id: \.self) { emoji in
                            Button(action: {
                                selectedEmoji = emoji
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }) {
                                Text(emoji)
                                    .font(.system(size: 30))
                                    .padding(8)
                                    .background(selectedEmoji == emoji ? Color.white.opacity(0.2) : Color.clear)
                                    .cornerRadius(12)
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    if let amount = Double(sendAmount) {
                        messages.append(Message(amount: amount, emoji: selectedEmoji, isMe: true))
                    }
                    showingSendMoneySheet = false
                    sendAmount = ""
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }) {
                    Text("send")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "1A1A14"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.theme.accentPrimary)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                .opacity(sendAmount.isEmpty ? 0.5 : 1.0)
                .disabled(sendAmount.isEmpty)
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.hidden)
    }
    
    private func handleUserMessage(_ text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        messages.append(Message(text: text, isMe: true))
        inputText = ""
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        guard chatName == "Rai" else { return }
        
        quickReplies = []
        isTyping = true
        
        let normalizedText = text.lowercased()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isTyping = false
            
            if normalizedText.contains("transaction") || normalizedText.contains("spending") || normalizedText.contains("100") || normalizedText.contains("📊") {
                // 100 Transactions spending analysis
                messages.append(Message(text: "analyzing your last 100 transactions... 🔍", isMe: false))
                
                isTyping = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                    isTyping = false
                    messages.append(Message(text: "i noticed you spent 4,200 ALL on coffee in the last month across 14 transactions! ☕️ that's about 15% of your total spending.", isMe: false))
                    
                    isTyping = true
                    DispatchQueue.main.pushDelay(1.2) {
                        isTyping = false
                        messages.append(Message(text: "would you like to set a Daily Coffee Cap goal to keep this in check? 🎯", isMe: false))
                        quickReplies = ["yes, set coffee goal 🎯", "no, i'm good ☕️"]
                        lastQuestionAsked = .transactionGoalPrompt
                    }
                }
            } else if normalizedText.contains("feature") || normalizedText.contains("explore") || normalizedText.contains("✨") {
                // Features presentation
                messages.append(Message(text: "here are some really useful features in the app: \n\n🎨 card customizer: style your debit card with gradient shades!\n\n📈 raipoints: earn rewards by completing quests!\n\n⚡️ kuik splits: split dinner or taxi bills instantly in chat.", isMe: false))
                
                isTyping = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                    isTyping = false
                    messages.append(Message(text: "which feature would you like to explore first?", isMe: false))
                    quickReplies = ["card customizer 🎨", "raipoints 📈", "kuik splits ⚡️"]
                    lastQuestionAsked = .features
                }
            } else if normalizedText.contains("feedback") || normalizedText.contains("opinion") || normalizedText.contains("💬") {
                // Feedback
                messages.append(Message(text: "i'm all ears! 🦅 what do you think of the app so far, or what features should we add next?", isMe: false))
                lastQuestionAsked = .feedback
            } else {
                // Context-based responses
                switch lastQuestionAsked {
                case .transactionGoalPrompt:
                    if normalizedText.contains("yes") || normalizedText.contains("set") || normalizedText.contains("🎯") {
                        messages.append(Message(text: "awesome! i've set up a 'Daily Coffee Cap' goal of 300 ALL. you can track it in your goals tracker! 🎯", isMe: false))
                    } else {
                        messages.append(Message(text: "no problem! keep enjoying your coffee. let me know if there's anything else you'd like to do! ☕️", isMe: false))
                    }
                    resetToMainOptions()
                    
                case .features:
                    if normalizedText.contains("card") || normalizedText.contains("customizer") || normalizedText.contains("🎨") {
                        messages.append(Message(text: "to customize your card, go to the home screen and tap your debit card. you can swatch different gradients there! 🎨", isMe: false))
                    } else if normalizedText.contains("point") || normalizedText.contains("raipoints") || normalizedText.contains("📈") {
                        messages.append(Message(text: "you can view your raipoints and active quests in the rewards tab. completing quests levels you up! 📈", isMe: false))
                    } else if normalizedText.contains("split") || normalizedText.contains("kuik") || normalizedText.contains("⚡️") {
                        messages.append(Message(text: "splitting is easy! just tap the '+' button in any chat with a friend (except this one!) to request a split. ⚡️", isMe: false))
                    } else {
                        messages.append(Message(text: "sounds good! let me know if you want to explore other features.", isMe: false))
                    }
                    resetToMainOptions()
                    
                case .feedback:
                    messages.append(Message(text: "thanks for sharing your feedback! i've saved it and passed it directly to our design & product team. we're always improving! 🚀", isMe: false))
                    resetToMainOptions()
                    
                default:
                    messages.append(Message(text: "i'm here to help! 🦅 would you like to check your transactions, explore useful features, or leave some feedback?", isMe: false))
                    quickReplies = ["analyze transactions 📊", "explore features ✨", "give feedback 💬"]
                    lastQuestionAsked = .welcome
                }
            }
        }
    }
    
    private func resetToMainOptions() {
        isTyping = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isTyping = false
            messages.append(Message(text: "what would you like to explore next?", isMe: false))
            quickReplies = ["analyze transactions 📊", "explore features ✨", "give feedback 💬"]
            lastQuestionAsked = .welcome
        }
    }
}

extension DispatchQueue {
    // Utility helper to safely chain delays inside simulation
    func pushDelay(_ delay: Double, completion: @escaping () -> Void) {
        self.asyncAfter(deadline: .now() + delay, execute: completion)
    }
}

// Subview for Message Bubbles
struct MessageBubble: View {
    let message: ChatDetailView.Message
    let chatName: String
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isMe { Spacer() }
            
            if !message.isMe && chatName == "Rai" {
                RaiAvatar(size: 28)
                    .overlay(Circle().stroke(Color.theme.accentPrimary, lineWidth: 1))
            }
            
            if message.isTransaction {
                // Transaction Bubble
                VStack(alignment: .trailing, spacing: 8) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.theme.canvas.opacity(0.3))
                                .frame(width: 40, height: 40)
                            Text(message.emoji ?? "💸")
                                .font(.system(size: 20))
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(message.isMe ? "you sent money" : "sent you money")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(hex: "1A1A14"))
                            Text(String(format: "%.2f ALL", message.amount ?? 0))
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "1A1A14"))
                        }
                    }
                }
                .padding(12)
                .background(Color.theme.accentPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                
            } else {
                // Text Bubble
                Text(message.text ?? "")
                    .font(.system(size: 15))
                    .foregroundColor(message.isMe ? Color(hex: "1A1A14") : .white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(message.isMe ? Color.theme.accentPrimary : Color.theme.surface2)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            
            if !message.isMe && chatName != "Rai" {
                // Spacer for other friends' chats
                Spacer()
            } else if message.isMe {
                // No spacer
            } else if chatName == "Rai" {
                Spacer()
            }
        }
    }
}

// Zoomed Rai Avatar reusable View
struct RaiAvatar: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Color.black
            
            Image("rai_cheer")
                .resizable()
                .scaledToFill()
                .scaleEffect(1.5, anchor: .top)
                .offset(y: size * 0.12)
                .frame(width: size, height: size)
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}
