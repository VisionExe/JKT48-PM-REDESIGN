//
//  ChatListView.swift
//  AtomicApplication
//
//  Created by Hillary Abigail on 18/07/25.
//

import SwiftUI
import SwiftData

struct ChatListView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var themeManager: ThemeManager
    @Query private var members: [JKT48Member]
    @Query private var messages: [Message]
    @State private var searchText = ""
    
    var subscribedMembers: [JKT48Member] {
        members.filter { $0.isSubscribed }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Search Bar
                searchSection
                
                // Chat List
                chatListSection
            }
            .background(JKT48Colors.groupedBackground)
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Chat")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(JKT48Colors.pinkGradient)
                
                Text("\(subscribedMembers.count) chat aktif")
                    .font(.subheadline)
                    .foregroundColor(JKT48Colors.secondaryLabel)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "square.and.pencil")
                    .font(.title2)
                    .foregroundColor(JKT48Colors.primaryPink)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 50)
        .padding(.bottom, 20)
    }
    
    private var searchSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(JKT48Colors.tertiaryLabel)
            
            TextField("Cari chat...", text: $searchText)
                .foregroundColor(JKT48Colors.primaryLabel)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(JKT48Colors.cardBackground(for: colorScheme))
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
    
    private var chatListSection: some View {
        ScrollView {
            LazyVStack(spacing: 1) {
                ForEach(subscribedMembers) { member in
                    ChatRowView(member: member)
                }
            }
        }
    }
}

struct ChatRowView: View {
    let member: JKT48Member
    @Environment(\.colorScheme) var colorScheme
    @Query private var messages: [Message]
    @State private var showingChatDetail = false
    
    var lastMessage: Message? {
        messages
            .filter { $0.senderId == member.id }
            .sorted { $0.timestamp > $1.timestamp }
            .first
    }
    
    var body: some View {
        Button(action: { showingChatDetail = true }) {
            HStack(spacing: 12) {
                // Profile Image
                ZStack {
                    Circle()
                        .fill(JKT48Colors.lightPink)
                        .frame(width: 56, height: 56)
                    
                    Text(member.nickname.prefix(1))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(JKT48Colors.primaryPink)
                    
                    if member.isOnline {
                        Circle()
                            .fill(JKT48Colors.systemGreen)
                            .frame(width: 14, height: 14)
                            .overlay(
                                Circle()
                                    .stroke(JKT48Colors.cardBackground(for: colorScheme), lineWidth: 2)
                            )
                            .offset(x: 20, y: 20)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(member.nickname)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(JKT48Colors.primaryLabel)
                        
                        Spacer()
                        
                        if let lastMessage = lastMessage {
                            Text(formatTime(lastMessage.timestamp))
                                .font(.caption)
                                .foregroundColor(JKT48Colors.tertiaryLabel)
                        }
                    }
                    
                    HStack {
                        Text(lastMessage?.content ?? "Mulai chat dengan \(member.nickname)")
                            .font(.caption)
                            .foregroundColor(JKT48Colors.secondaryLabel)
                            .lineLimit(2)
                        
                        Spacer()
                        
                        if member.messageCount > 0 {
                            Circle()
                                .fill(JKT48Colors.primaryPink)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Text("\(min(member.messageCount, 99))")
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                )
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(JKT48Colors.cardBackground(for: colorScheme))
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingChatDetail) {
            ChatDetailView(member: member)
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: date)
    }
}

struct ChatDetailView: View {
    let member: JKT48Member
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Query private var messages: [Message]
    @State private var newMessage = ""
    @State private var showingVoiceNote = false
    
    var memberMessages: [Message] {
        messages
            .filter { $0.senderId == member.id }
            .sorted { $0.timestamp < $1.timestamp }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Chat Header
                chatHeader
                
                // Messages
                messagesSection
                
                // Input Section
                messageInputSection
            }
            .background(JKT48Colors.groupedBackground)
        }
    }
    
    private var chatHeader: some View {
        HStack(spacing: 12) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundColor(JKT48Colors.primaryPink)
            }
            
            Circle()
                .fill(JKT48Colors.lightPink)
                .frame(width: 40, height: 40)
                .overlay(
                    Text(member.nickname.prefix(1))
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(JKT48Colors.primaryPink)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(member.nickname)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(JKT48Colors.primaryLabel)
                
                Text(member.isOnline ? "Online" : "Offline")
                    .font(.caption)
                    .foregroundColor(member.isOnline ? JKT48Colors.systemGreen : JKT48Colors.tertiaryLabel)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "phone")
                    .font(.title3)
                    .foregroundColor(JKT48Colors.primaryPink)
            }
            
            Button(action: {}) {
                Image(systemName: "video")
                    .font(.title3)
                    .foregroundColor(JKT48Colors.primaryPink)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(JKT48Colors.cardBackground(for: colorScheme))
    }
    
    private var messagesSection: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(memberMessages) { message in
                    MessageBubbleView(message: message, member: member)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
    
    private var messageInputSection: some View {
        HStack(spacing: 12) {
            Button(action: {}) {
                Image(systemName: "camera")
                    .font(.title3)
                    .foregroundColor(JKT48Colors.primaryPink)
            }
            
            HStack {
                TextField("Ketik pesan...", text: $newMessage)
                    .foregroundColor(JKT48Colors.primaryLabel)
                
                Button(action: { showingVoiceNote.toggle() }) {
                    Image(systemName: "mic")
                        .font(.title3)
                        .foregroundColor(JKT48Colors.primaryPink)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(JKT48Colors.cardBackground(for: colorScheme))
            .cornerRadius(20)
            
            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(JKT48Colors.primaryPink)
                    .cornerRadius(20)
            }
            .disabled(newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(JKT48Colors.cardBackground(for: colorScheme))
    }
    
    private func sendMessage() {
        // Implementation for sending message
        newMessage = ""
    }
}

struct MessageBubbleView: View {
    let message: Message
    let member: JKT48Member
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            if message.isFromMember {
                // Member's message (left side)
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(JKT48Colors.lightPink)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Text(member.nickname.prefix(1))
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(JKT48Colors.primaryPink)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(message.content)
                            .messageBubble(isFromUser: false)
                        
                        Text(formatMessageTime(message.timestamp))
                            .font(.caption2)
                            .foregroundColor(JKT48Colors.tertiaryLabel)
                    }
                    
                    Spacer()
                }
            } else {
                // User's message (right side)
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .messageBubble(isFromUser: true)
                    
                    Text(formatMessageTime(message.timestamp))
                        .font(.caption2)
                        .foregroundColor(JKT48Colors.tertiaryLabel)
                }
            }
        }
    }
    
    private func formatMessageTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: date)
    }
}