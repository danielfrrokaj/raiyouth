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
    
    @State private var messages: [Message] = [
        Message(text: "Hey! Thanks for getting the tickets.", isMe: false),
        Message(text: "No problem!", isMe: true),
        Message(amount: 25.00, emoji: "🎟️", isMe: true)
    ]
    
    @State private var inputText: String = ""
    @State private var showingSendMoneySheet = false
    @State private var sendAmount: String = ""
    @State private var selectedEmoji: String = "💸"
    
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
                    
                    let initials = chatName.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined()
                    
                    ZStack(alignment: .bottomTrailing) {
                        Circle()
                            .fill(Color.white.opacity(0.12))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Text(initials)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            )
                        
                        if isOnline {
                            Circle()
                                .fill(Color.theme.success)
                                .frame(width: 12, height: 12)
                                .overlay(Circle().stroke(Color.theme.canvas, lineWidth: 2))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(chatName)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        if isOnline {
                            Text("Active now")
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
                            ForEach(messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages.count) { _ in
                        if let lastId = messages.last?.id {
                            withAnimation {
                                proxy.scrollTo(lastId, anchor: .bottom)
                            }
                        }
                    }
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
                    
                    HStack {
                        TextField("Message...", text: $inputText)
                            .foregroundColor(.white)
                            .accentColor(Color.theme.accentPrimary)
                        
                        if !inputText.isEmpty {
                            Button(action: {
                                sendMessage()
                            }) {
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(Color.theme.accentPrimary)
                                    .font(.system(size: 18))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(20)
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
    
    private var sendMoneySheet: some View {
        ZStack {
            Color.theme.canvas.ignoresSafeArea()
            VStack(spacing: 24) {
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 40, height: 4)
                    .padding(.top, 12)
                
                Text("Send Money")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 8) {
                    Text("Amount")
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
                    Text("Add an emoji")
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
                    Text("Send")
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
    
    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        messages.append(Message(text: inputText, isMe: true))
        inputText = ""
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

// Subview for Message Bubbles
struct MessageBubble: View {
    let message: ChatDetailView.Message
    
    var body: some View {
        HStack {
            if message.isMe { Spacer() }
            
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
                            Text(message.isMe ? "You sent money" : "Sent you money")
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
            
            if !message.isMe { Spacer() }
        }
    }
}
