import SwiftUI

struct MessagesView: View {
    @State private var showingSplitModal = false
    @State private var splitAmount = ""
    
    struct ChatMessage: Identifiable {
        let id = UUID()
        var name: String
        var lastMessage: String
        var time: String
        var unread: Bool
        var pendingSplit: Double?
        var isOnline: Bool
    }
    
    @State private var chats = [
        ChatMessage(name: "Rai", lastMessage: "I've analyzed your last 100 transactions...", time: "18:48", unread: true, pendingSplit: nil, isOnline: true),
        ChatMessage(name: "Sarah Jenkins", lastMessage: "Let's split the coffee bill from earlier!", time: "12:30", unread: true, pendingSplit: 4.50, isOnline: true),
        ChatMessage(name: "Alex Vlasic", lastMessage: "Reacted 👍 to your transfer.", time: "Yesterday", unread: false, pendingSplit: nil, isOnline: true),
        ChatMessage(name: "Friday Dinner Group", lastMessage: "Daniel: I paid for the taxi.", time: "Friday", unread: false, pendingSplit: 18.00, isOnline: false),
        ChatMessage(name: "Mom", lastMessage: "Have a safe flight back!", time: "Thursday", unread: false, pendingSplit: nil, isOnline: false)
    ]
    
    // Active friends tray (Instagram like)
    let activeFriends = [
        ("Rai", "Rai"),
        ("Sarah Jenkins", "SJ"),
        ("Alex Vlasic", "AV"),
        ("Emily Carter", "EC"),
        ("John Doe", "JD"),
        ("Dave Miller", "DM")
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: Theme.Spacing.lg) {
                Spacer().frame(height: 16)
                
                // Instagram-style active status tray
                VStack(alignment: .leading, spacing: 10) {
                    Text("Active now")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.horizontal, Theme.Spacing.lg)
                        .textCase(.uppercase)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(activeFriends, id: \.0) { friend in
                                NavigationLink(destination: ChatDetailView(chatName: friend.0, isOnline: true)) {
                                    VStack(spacing: 6) {
                                        ZStack(alignment: .bottomTrailing) {
                                            if friend.0 == "Rai" {
                                                RaiAvatar(size: 56)
                                                    .overlay(Circle().stroke(Color.theme.accentPrimary, lineWidth: 1.5))
                                            } else {
                                                Circle()
                                                    .fill(Color.white.opacity(0.12))
                                                    .frame(width: 56, height: 56)
                                                    .overlay(
                                                        Text(friend.1)
                                                            .font(.system(size: 16, weight: .bold))
                                                            .foregroundColor(.white)
                                                    )
                                            }
                                            
                                            // Active green dot
                                            Circle()
                                                .fill(Color.theme.success)
                                                .frame(width: 14, height: 14)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.theme.canvas, lineWidth: 2)
                                                )
                                        }
                                        
                                        Text(friend.0.split(separator: " ").first ?? "")
                                            .font(.system(size: 11, weight: .medium))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                    }
                }
                .padding(.top, 4)
                
                // Divider
                Rectangle()
                    .fill(Color.white.opacity(0.08))
                    .frame(height: 1)
                    .padding(.horizontal, Theme.Spacing.lg)
                
                // Chats header & Split action button
                HStack {
                    Text("Messages")
                        .themeFont(.h2)
                        .foregroundColor(.white)
                    Spacer()
                    
                    Button(action: {
                        showingSplitModal = true
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus.forwardslash.minus")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(hex: "1A1A14"))
                            Text("Split bill")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "1A1A14"))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.theme.accentPrimary)
                        .cornerRadius(14)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, Theme.Spacing.lg)
                
                // Chat List Unified Container
                VStack(spacing: Theme.Spacing.sm) {
                    VStack(spacing: 0) {
                        ForEach(Array(chats.enumerated()), id: \.element.id) { idx, chat in
                            VStack(spacing: 0) {
                                NavigationLink(destination: ChatDetailView(chatName: chat.name, isOnline: chat.isOnline)) {
                                    HStack(spacing: Theme.Spacing.md) {
                                        ZStack(alignment: .bottomTrailing) {
                                            if chat.name == "Rai" {
                                                RaiAvatar(size: 44)
                                                    .overlay(Circle().stroke(Color.theme.accentPrimary, lineWidth: 1.5))
                                            } else {
                                                let initials = chat.name.split(separator: " ").compactMap { $0.first }.map { String($0) }.joined()
                                                Circle()
                                                    .fill(chat.unread ? Color.theme.accentPrimary : Color.white.opacity(0.12))
                                                    .frame(width: 44, height: 44)
                                                    .overlay(
                                                        Text(initials)
                                                            .font(.system(size: 14, weight: .bold))
                                                            .foregroundColor(chat.unread ? Color(hex: "1A1A14") : .white)
                                                    )
                                            }
                                            
                                            if chat.isOnline {
                                                Circle()
                                                    .fill(Color.theme.success)
                                                    .frame(width: 12, height: 12)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(Color.theme.canvas, lineWidth: 2)
                                                    )
                                            }
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 3) {
                                            HStack(spacing: 6) {
                                                Text(chat.name)
                                                    .font(.system(size: 15, weight: chat.unread ? .bold : .semibold))
                                                    .foregroundColor(.white)
                                                
                                                if chat.name == "Rai" {
                                                    // Small badge next to the name, no AI text
                                                    Text("assistant")
                                                        .font(.system(size: 10, weight: .bold))
                                                        .foregroundColor(Color.theme.accentPrimary)
                                                        .padding(.horizontal, 6)
                                                        .padding(.vertical, 2)
                                                        .background(Color.theme.accentPrimary.opacity(0.15))
                                                        .cornerRadius(4)
                                                }
                                            }
                                            
                                            Text(chat.lastMessage)
                                                .font(.system(size: 12))
                                                .foregroundColor(chat.unread ? .white : .white.opacity(0.6))
                                                .lineLimit(1)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 3) {
                                            Text(chat.time)
                                                .font(.system(size: 11))
                                                .foregroundColor(.white.opacity(0.5))
                                            
                                            if chat.unread {
                                                Circle()
                                                    .fill(Color.theme.accentPrimary)
                                                    .frame(width: 8, height: 8)
                                            } else {
                                                Image(systemName: "camera")
                                                    .foregroundColor(.white.opacity(0.4))
                                                    .font(.system(size: 15))
                                            }
                                        }
                                    }
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, Theme.Spacing.lg)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                // Pending split request card
                                if let split = chat.pendingSplit {
                                    HStack(spacing: Theme.Spacing.md) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.theme.accentPrimary.opacity(0.12))
                                                .frame(width: 32, height: 32)
                                            Image(systemName: "plus.forwardslash.minus")
                                                .foregroundColor(Color.theme.accentPrimary)
                                                .font(.system(size: 12, weight: .bold))
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Split request")
                                                .font(.system(size: 11, weight: .bold))
                                                .foregroundColor(.white)
                                            Text(String(format: "%.2f € requested", split))
                                                .font(.system(size: 10))
                                                .foregroundColor(.white.opacity(0.7))
                                        }
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 8) {
                                            Button(action: {
                                                if let index = chats.firstIndex(where: { $0.id == chat.id }) {
                                                    chats[index].pendingSplit = nil
                                                }
                                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                            }) {
                                                Text("Pay")
                                                    .font(.system(size: 10, weight: .bold))
                                                    .foregroundColor(Color(hex: "1A1A14"))
                                                    .padding(.horizontal, 10)
                                                    .padding(.vertical, 5)
                                                    .background(Color.theme.accentPrimary)
                                                    .cornerRadius(10)
                                            }
                                            
                                            Button(action: {
                                                if let index = chats.firstIndex(where: { $0.id == chat.id }) {
                                                    chats[index].pendingSplit = nil
                                                }
                                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                            }) {
                                                Text("Decline")
                                                    .font(.system(size: 10, weight: .bold))
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 5)
                                                    .background(.ultraThinMaterial)
                                                    .cornerRadius(10)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                                    )
                                            }
                                        }
                                    }
                                    .padding(8)
                                    .background(Color.white.opacity(0.04))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                    )
                                    .padding(.horizontal, Theme.Spacing.lg)
                                    .padding(.bottom, 12)
                                }
                            }
                            
                            if idx < chats.count - 1 {
                                Rectangle()
                                    .fill(Color.white.opacity(0.05))
                                    .frame(height: 1)
                                    .padding(.horizontal, Theme.Spacing.lg + 52)
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
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.bottom, 120) // Give space for bottom nav
            }
        }
        .background(Color.theme.canvas.ignoresSafeArea())
        .tint(.white) // Native back button color
        // Split Bill Modal
        .sheet(isPresented: $showingSplitModal) {
            ZStack {
                Color.theme.canvas.ignoresSafeArea()
                VStack(spacing: 24) {
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 40, height: 4)
                        .padding(.top, 12)
                    
                    Text("Split a bill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 8) {
                        Text("Amount")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                        
                        TextField("0.00", text: $splitAmount)
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .keyboardType(.decimalPad)
                        
                        Text("ALL")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color.theme.accentPrimary)
                    }
                    .padding(.vertical, 32)
                    
                    Spacer()
                    
                    Button(action: {
                        showingSplitModal = false
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }) {
                        Text("Select friends")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(hex: "1A1A14"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.theme.accentPrimary)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.hidden)
        }
    }
}

#Preview {
    MessagesView()
}
