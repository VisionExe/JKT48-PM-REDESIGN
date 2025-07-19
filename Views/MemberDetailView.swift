//
//  MemberDetailView.swift
//  AtomicApplication
//
//  Created by Hillary Abigail on 18/07/25.
//

import SwiftUI
import SwiftData

struct MemberDetailView: View {
    let member: JKT48Member
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext
    @State private var showingSubscriptionSheet = false
    @State private var showingChatView = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Header with background gradient
                    headerSection
                    
                    // Member info and actions
                    memberInfoSection
                    
                    // Gallery/Photos
                    gallerySection
                    
                    // Recent messages
                    recentMessagesSection
                }
            }
            .background(JKT48Colors.groupedBackground)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingSubscriptionSheet) {
            SubscriptionView(member: member)
        }
        .sheet(isPresented: $showingChatView) {
            ChatDetailView(member: member)
        }
    }
    
    private var headerSection: some View {
        ZStack(alignment: .top) {
            // Background gradient
            LinearGradient(
                colors: [JKT48Colors.primaryPink.opacity(0.8), JKT48Colors.lightPink.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 300)
            
            VStack(spacing: 20) {
                // Navigation
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.black.opacity(0.2)))
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "heart.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.black.opacity(0.2)))
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.black.opacity(0.2)))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                
                // Profile image and basic info
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 120, height: 120)
                            .shadow(radius: 10)
                        
                        Circle()
                            .fill(JKT48Colors.lightPink)
                            .frame(width: 110, height: 110)
                        
                        Text(member.nickname.prefix(1))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(JKT48Colors.primaryPink)
                        
                        if member.isOnline {
                            Circle()
                                .fill(JKT48Colors.systemGreen)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Circle()
                                        .stroke(.white, lineWidth: 3)
                                )
                                .offset(x: 40, y: 40)
                        }
                    }
                    
                    VStack(spacing: 8) {
                        Text(member.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("\(member.team) • \(member.generation)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text("\(member.subscriberCount.formatted()) subscribers")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private var memberInfoSection: some View {
        VStack(spacing: 20) {
            // Action buttons
            HStack(spacing: 12) {
                Button(action: { 
                    if member.isSubscribed {
                        showingChatView = true
                    } else {
                        showingSubscriptionSheet = true
                    }
                }) {
                    HStack {
                        Image(systemName: member.isSubscribed ? "message.fill" : "heart.fill")
                        Text(member.isSubscribed ? "Chat" : "Subscribe")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .foregroundColor(.white)
                    .background(JKT48Colors.primaryPink)
                    .cornerRadius(25)
                }
                
                if member.isSubscribed {
                    Button(action: { showingSubscriptionSheet = true }) {
                        Image(systemName: "crown.fill")
                            .font(.title3)
                            .foregroundColor(JKT48Colors.primaryPink)
                            .frame(width: 50, height: 50)
                            .background(JKT48Colors.lightPink)
                            .cornerRadius(25)
                    }
                }
                
                Button(action: {}) {
                    Image(systemName: "bell.fill")
                        .font(.title3)
                        .foregroundColor(JKT48Colors.primaryPink)
                        .frame(width: 50, height: 50)
                        .background(JKT48Colors.lightPink)
                        .cornerRadius(25)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, -30)
            
            // Member bio and details
            VStack(alignment: .leading, spacing: 16) {
                if !member.bio.isEmpty {
                    Text(member.bio)
                        .font(.subheadline)
                        .foregroundColor(JKT48Colors.primaryLabel)
                        .multilineTextAlignment(.leading)
                }
                
                // Details grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    DetailCard(icon: "heart.fill", title: "Hobby", value: member.hobby.isEmpty ? "Music, Dance" : member.hobby)
                    DetailCard(icon: "star.fill", title: "Special Skill", value: member.specialSkill.isEmpty ? "Singing" : member.specialSkill)
                    DetailCard(icon: "person.3.fill", title: "Team", value: member.team)
                    DetailCard(icon: "number", title: "Generation", value: member.generation)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var gallerySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Gallery")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(JKT48Colors.primaryLabel)
                
                Spacer()
                
                Button("Lihat Semua") {}
                    .font(.subheadline)
                    .foregroundColor(JKT48Colors.primaryPink)
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<6, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(JKT48Colors.lightPink)
                            .frame(width: 120, height: 160)
                            .overlay(
                                VStack {
                                    Image(systemName: "photo")
                                        .font(.title)
                                        .foregroundColor(JKT48Colors.primaryPink)
                                    Text("Photo \(index + 1)")
                                        .font(.caption)
                                        .foregroundColor(JKT48Colors.primaryPink)
                                }
                            )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 20)
    }
    
    private var recentMessagesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Pesan Terbaru")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(JKT48Colors.primaryLabel)
                
                Spacer()
                
                if member.isSubscribed {
                    Button("Lihat Chat") { showingChatView = true }
                        .font(.subheadline)
                        .foregroundColor(JKT48Colors.primaryPink)
                }
            }
            .padding(.horizontal, 20)
            
            if member.isSubscribed {
                VStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { index in
                        HStack(alignment: .top, spacing: 12) {
                            Circle()
                                .fill(JKT48Colors.lightPink)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text(member.nickname.prefix(1))
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(JKT48Colors.primaryPink)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Halo! Terima kasih sudah berlangganan. Aku akan share banyak hal menarik disini! 💖")
                                    .font(.subheadline)
                                    .foregroundColor(JKT48Colors.primaryLabel)
                                
                                Text("2 jam lalu")
                                    .font(.caption)
                                    .foregroundColor(JKT48Colors.tertiaryLabel)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "lock.fill")
                        .font(.largeTitle)
                        .foregroundColor(JKT48Colors.primaryPink)
                    
                    Text("Berlangganan untuk melihat pesan")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(JKT48Colors.primaryLabel)
                    
                    Text("Dapatkan akses eksklusif ke pesan dan konten dari \(member.nickname)")
                        .font(.caption)
                        .foregroundColor(JKT48Colors.secondaryLabel)
                        .multilineTextAlignment(.center)
                    
                    Button(action: { showingSubscriptionSheet = true }) {
                        Text("Mulai Berlangganan")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(JKT48Colors.primaryPink)
                            .cornerRadius(20)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
            }
        }
        .padding(.vertical, 20)
        .padding(.bottom, 100)
    }
}

struct DetailCard: View {
    let icon: String
    let title: String
    let value: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(JKT48Colors.primaryPink)
                    .font(.caption)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(JKT48Colors.secondaryLabel)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(JKT48Colors.primaryLabel)
                    .lineLimit(2)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .jkt48Card()
    }
}