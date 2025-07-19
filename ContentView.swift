//
//  ContentView.swift
//  AtomicApplication
//
//  Created by Hillary Abigail on 18/07/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var themeManager = ThemeManager()
    @Query private var members: [JKT48Member]
    @Query private var messages: [Message]
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home/Messages Tab
            NavigationStack {
                HomeView()
                    .environmentObject(themeManager)
            }
            .tabItem {
                Image(systemName: "message.fill")
                Text("Pesan")
            }
            .tag(0)
            
            // Members Tab
            NavigationStack {
                MembersView()
                    .environmentObject(themeManager)
            }
            .tabItem {
                Image(systemName: "person.3.fill")
                Text("Member")
            }
            .tag(1)
            
            // Chat Tab
            NavigationStack {
                ChatListView()
                    .environmentObject(themeManager)
            }
            .tabItem {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                Text("Chat")
            }
            .tag(2)
            
            // Profile Tab
            NavigationStack {
                ProfileView()
                    .environmentObject(themeManager)
            }
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text("Profil")
            }
            .tag(3)
        }
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        .accentColor(JKT48Colors.primaryPink)
        .onAppear {
            createDemoDataIfNeeded()
        }
    }
    
    private func createDemoDataIfNeeded() {
        if members.isEmpty {
            createDemoMembers()
        }
        if messages.isEmpty {
            createDemoMessages()
        }
    }
    
    private func createDemoMembers() {
        let demoMembers = [
            JKT48Member(name: "Shani Indira Natio", nickname: "Shani", team: "Team KIII", generation: "Gen 1"),
            JKT48Member(name: "Christy Lyn", nickname: "Christy", team: "Team KIII", generation: "Gen 7"),
            JKT48Member(name: "Freya Jayawardana", nickname: "Freya", team: "Team KIII", generation: "Gen 8"),
            JKT48Member(name: "Azizi Asadel", nickname: "Zee", team: "Team J", generation: "Gen 7"),
            JKT48Member(name: "Fiony Alveria", nickname: "Fiony", team: "Team J", generation: "Gen 8"),
            JKT48Member(name: "Mutiara Azzahra", nickname: "Muthe", team: "Team J", generation: "Gen 8"),
            JKT48Member(name: "Flora Shafiq", nickname: "Flo", team: "Team T", generation: "Gen 9"),
            JKT48Member(name: "Indira Seruni", nickname: "Indira", team: "Team T", generation: "Gen 9"),
        ]
        
        for member in demoMembers {
            member.bio = "Halo! Aku \(member.nickname) dari \(member.team) JKT48! 💖"
            member.hobby = "Menyanyi, Menari"
            member.specialSkill = "MC, Variety Show"
            modelContext.insert(member)
        }
    }
    
    private func createDemoMessages() {
        guard let firstMember = members.first else { return }
        
        let demoMessages = [
            Message(
                senderId: firstMember.id,
                senderName: firstMember.name,
                content: "Halo semuanya! Hari ini aku mau share foto dari behind the scene theater show kemarin 📸✨",
                isFromMember: true
            ),
            Message(
                senderId: firstMember.id,
                senderName: firstMember.name,
                content: "Terima kasih untuk semua dukungannya di konser kemarin! Kalian luar biasa! 💖",
                isFromMember: true
            ),
            Message(
                senderId: firstMember.id,
                senderName: firstMember.name,
                content: "Jangan lupa nonton theater show aku minggu depan ya! See you there! 🎭",
                isFromMember: true
            )
        ]
        
        for message in demoMessages {
            modelContext.insert(message)
        }
    }
}

// MARK: - Home View (Message Feed)
struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var themeManager: ThemeManager
    @Query private var messages: [Message]
    @Query private var members: [JKT48Member]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Header
                headerSection
                
                // Stories Section
                storiesSection
                
                // Messages Feed
                messagesFeedSection
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(JKT48Colors.groupedBackground)
        .navigationBarHidden(true)
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("JKT48 Message")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(JKT48Colors.pinkGradient)
                
                Text("Terhubung dengan idola favoritmu")
                    .font(.subheadline)
                    .foregroundColor(JKT48Colors.secondaryLabel)
            }
            
            Spacer()
            
            Button(action: { themeManager.toggleTheme() }) {
                Image(systemName: themeManager.isDarkMode ? "sun.max" : "moon")
                    .font(.title2)
                    .foregroundColor(JKT48Colors.primaryPink)
            }
        }
        .padding(.top, 50)
        .padding(.bottom, 20)
    }
    
    private var storiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Stories")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(JKT48Colors.primaryLabel)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(members.prefix(8)) { member in
                        StoryCard(member: member)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private var messagesFeedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pesan Terbaru")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(JKT48Colors.primaryLabel)
            
            LazyVStack(spacing: 12) {
                ForEach(messages.sorted(by: { $0.timestamp > $1.timestamp })) { message in
                    MessageCard(message: message)
                }
            }
        }
    }
}

// MARK: - Story Card Component
struct StoryCard: View {
    let member: JKT48Member
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(
                        member.isOnline ? JKT48Colors.primaryPink : Color.gray.opacity(0.3),
                        lineWidth: 2
                    )
                    .frame(width: 70, height: 70)
                
                Circle()
                    .fill(JKT48Colors.lightPink)
                    .frame(width: 64, height: 64)
                
                Text(member.nickname.prefix(1))
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(JKT48Colors.primaryPink)
                
                if member.isOnline {
                    Circle()
                        .fill(JKT48Colors.systemGreen)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Circle()
                                .stroke(JKT48Colors.cardBackground(for: colorScheme), lineWidth: 2)
                        )
                        .offset(x: 22, y: 22)
                }
            }
            
            Text(member.nickname)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(JKT48Colors.primaryLabel)
                .lineLimit(1)
        }
        .frame(width: 80)
    }
}

// MARK: - Message Card Component
struct MessageCard: View {
    let message: Message
    @Query private var members: [JKT48Member]
    
    var member: JKT48Member? {
        members.first { $0.id == message.senderId }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Member info
            HStack(spacing: 12) {
                Circle()
                    .fill(JKT48Colors.lightPink)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(member?.nickname.prefix(1) ?? "?")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(JKT48Colors.primaryPink)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(member?.nickname ?? "Unknown")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(JKT48Colors.primaryLabel)
                    
                    Text(formatMessageTime(message.timestamp))
                        .font(.caption)
                        .foregroundColor(JKT48Colors.tertiaryLabel)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "heart")
                        .font(.title3)
                        .foregroundColor(JKT48Colors.primaryPink)
                }
            }
            
            // Message content
            Text(message.content)
                .font(.subheadline)
                .foregroundColor(JKT48Colors.primaryLabel)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .jkt48Card()
    }
    
    private func formatMessageTime(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
