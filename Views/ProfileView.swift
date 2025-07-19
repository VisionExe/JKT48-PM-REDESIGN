//
//  ProfileView.swift
//  AtomicApplication
//
//  Created by Hillary Abigail on 18/07/25.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var themeManager: ThemeManager
    @Query private var users: [User]
    @Query private var members: [JKT48Member]
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    @State private var animateProfile = false
    
    var currentUser: User? {
        users.first
    }
    
    var subscribedMembers: [JKT48Member] {
        members.filter { $0.isSubscribed }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Modern Header Section
                    modernHeaderSection
                    
                    // Enhanced Profile Info
                    modernProfileInfoSection
                    
                    // Subscription Status with better design
                    modernSubscriptionSection
                    
                    // Quick Actions Grid
                    modernQuickActionsSection
                    
                    // Settings with modern styling
                    modernSettingsSection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
            .background(JKT48Colors.primaryBackground)
            .onAppear {
                withAnimation(.spring(response: 1.0, dampingFraction: 0.8)) {
                    animateProfile = true
                }
            }
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(user: currentUser)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
    
    private var modernHeaderSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Profil")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(JKT48Colors.pinkGradient)
                
                Text("Kelola akun JKT48 Message Anda")
                    .font(.subheadline)
                    .foregroundColor(JKT48Colors.secondaryLabel)
            }
            
            Spacer()
            
            Button(action: { showingSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundColor(JKT48Colors.primaryPink)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(JKT48Colors.primaryPink.opacity(0.1))
                    )
            }
        }
        .padding(.top, 20)
        .scaleEffect(animateProfile ? 1.0 : 0.9)
        .opacity(animateProfile ? 1.0 : 0.0)
        .animation(.spring(response: 1.2, dampingFraction: 0.8), value: animateProfile)
    }
    
    private var modernProfileInfoSection: some View {
        VStack(spacing: 20) {
            // Enhanced Profile Image and Info
            HStack(spacing: 20) {
                Button(action: { showingEditProfile = true }) {
                    ZStack {
                        Circle()
                            .fill(JKT48Colors.lightPinkGradient)
                            .frame(width: 90, height: 90)
                            .shadow(
                                color: JKT48Colors.primaryPink.opacity(0.3),
                                radius: 15,
                                x: 0,
                                y: 8
                            )
                        
                        if let imageData = currentUser?.profileImageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 85, height: 85)
                                .clipShape(Circle())
                        } else {
                            Text(currentUser?.name.prefix(1).uppercased() ?? "U")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        // Modern edit indicator
                        Circle()
                            .fill(JKT48Colors.primaryPink)
                            .frame(width: 28, height: 28)
                            .overlay(
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                            )
                            .offset(x: 30, y: 30)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(currentUser?.name ?? "Pengguna Baru")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(JKT48Colors.primaryLabel)
                    
                    Text(currentUser?.email ?? "email@example.com")
                        .font(.subheadline)
                        .foregroundColor(JKT48Colors.secondaryLabel)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "calendar.circle.fill")
                            .foregroundColor(JKT48Colors.primaryPink)
                            .font(.caption)
                        
                        Text("Member sejak \(formatDate(currentUser?.createdAt ?? Date()))")
                            .font(.caption)
                            .foregroundColor(JKT48Colors.tertiaryLabel)
                    }
                }
                
                Spacer()
            }
            
            // Enhanced Stats Row
            HStack(spacing: 25) {
                ModernStatItem(
                    value: "\(subscribedMembers.count)",
                    label: "Subscribed",
                    color: JKT48Colors.primaryPink
                )
                
                Divider()
                    .frame(height: 40)
                    .background(JKT48Colors.tertiaryLabel.opacity(0.3))
                
                ModernStatItem(
                    value: "\(members.filter { $0.messageCount > 0 }.count)",
                    label: "Chats",
                    color: JKT48Colors.systemBlue
                )
                
                Divider()
                    .frame(height: 40)
                    .background(JKT48Colors.tertiaryLabel.opacity(0.3))
                
                ModernStatItem(
                    value: "Premium",
                    label: "Status",
                    color: JKT48Colors.systemOrange
                )
            }
            .padding(.top, 10)
        }
        .padding(24)
        .modernCard()
        .scaleEffect(animateProfile ? 1.0 : 0.9)
        .opacity(animateProfile ? 1.0 : 0.0)
        .animation(.spring(response: 1.4, dampingFraction: 0.8).delay(0.2), value: animateProfile)
    }
    
    private var modernSubscriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Langganan Aktif")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(JKT48Colors.primaryLabel)
                
                Spacer()
                
                if !subscribedMembers.isEmpty {
                    Text("\(subscribedMembers.count) aktif")
                        .font(.caption)
                        .foregroundColor(JKT48Colors.secondaryLabel)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(JKT48Colors.primaryPink.opacity(0.1))
                        )
                }
            }
            
            if subscribedMembers.isEmpty {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(JKT48Colors.primaryPink.opacity(0.1))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "star.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(JKT48Colors.primaryPink)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Belum ada langganan")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(JKT48Colors.primaryLabel)
                        
                        Text("Mulai berlangganan member favoritmu")
                            .font(.caption)
                            .foregroundColor(JKT48Colors.secondaryLabel)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(action: {}) {
                        HStack(spacing: 8) {
                            Image(systemName: "person.3.fill")
                            Text("Jelajahi Member")
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(JKT48Colors.pinkGradient)
                        .clipShape(Capsule())
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                // Show subscribed members in a nice grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(subscribedMembers.prefix(4), id: \.id) { member in
                        SubscribedMemberCard(member: member)
                    }
                }
                
                if subscribedMembers.count > 4 {
                    Button("Lihat Semua (\(subscribedMembers.count))") {
                        // Navigate to full list
                    }
                    .font(.caption)
                    .foregroundColor(JKT48Colors.primaryPink)
                    .padding(.top, 8)
                }
            }
        }
        .padding(20)
        .modernCard()
        .scaleEffect(animateProfile ? 1.0 : 0.9)
        .opacity(animateProfile ? 1.0 : 0.0)
        .animation(.spring(response: 1.6, dampingFraction: 0.8).delay(0.4), value: animateProfile)
    }
    
    private var modernQuickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Aksi Cepat")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(JKT48Colors.primaryLabel)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                QuickActionCard(
                    icon: "person.circle.fill",
                    title: "Edit Profil",
                    subtitle: "Ubah info personal",
                    color: JKT48Colors.systemBlue,
                    action: { showingEditProfile = true }
                )
                
                QuickActionCard(
                    icon: "bell.circle.fill",
                    title: "Notifikasi",
                    subtitle: "Atur preferensi",
                    color: JKT48Colors.systemOrange,
                    action: { /* Handle notifications */ }
                )
                
                QuickActionCard(
                    icon: "heart.circle.fill",
                    title: "Favorit",
                    subtitle: "Member favorit",
                    color: JKT48Colors.systemRed,
                    action: { /* Handle favorites */ }
                )
                
                QuickActionCard(
                    icon: "crown.circle.fill",
                    title: "Premium",
                    subtitle: "Upgrade akun",
                    color: JKT48Colors.primaryPink,
                    action: { /* Handle premium */ }
                )
            }
        }
        .padding(20)
        .modernCard()
        .scaleEffect(animateProfile ? 1.0 : 0.9)
        .opacity(animateProfile ? 1.0 : 0.0)
        .animation(.spring(response: 1.8, dampingFraction: 0.8).delay(0.6), value: animateProfile)
    }
    
    private var modernSettingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pengaturan")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(JKT48Colors.primaryLabel)
            
            VStack(spacing: 12) {
                ModernSettingsRow(
                    icon: "gearshape.fill",
                    title: "Pengaturan Umum",
                    subtitle: "Tema, bahasa, dan lainnya",
                    color: JKT48Colors.systemBlue,
                    action: { showingSettings = true }
                )
                
                ModernSettingsRow(
                    icon: "lock.shield.fill",
                    title: "Keamanan",
                    subtitle: "Password dan privasi",
                    color: JKT48Colors.systemGreen,
                    action: { /* Handle security */ }
                )
                
                ModernSettingsRow(
                    icon: "questionmark.circle.fill",
                    title: "Bantuan",
                    subtitle: "FAQ dan dukungan",
                    color: JKT48Colors.systemPurple,
                    action: { /* Handle help */ }
                )
                
                ModernSettingsRow(
                    icon: "arrow.right.square.fill",
                    title: "Keluar",
                    subtitle: "Logout dari akun",
                    color: JKT48Colors.systemRed,
                    action: { /* Handle logout */ }
                )
            }
        }
        .padding(20)
        .modernCard()
        .scaleEffect(animateProfile ? 1.0 : 0.9)
        .opacity(animateProfile ? 1.0 : 0.0)
        .animation(.spring(response: 2.0, dampingFraction: 0.8).delay(0.8), value: animateProfile)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: date)
    }
}

// MARK: - Modern Profile Components

struct ModernStatItem: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(label)
                .font(.caption)
                .foregroundColor(JKT48Colors.secondaryLabel)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SubscribedMemberCard: View {
    let member: JKT48Member
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: member.profileImageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(JKT48Colors.lightPinkGradient)
                    .overlay(
                        Text(member.name.prefix(1))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            
            VStack(spacing: 2) {
                Text(member.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(JKT48Colors.primaryLabel)
                    .lineLimit(1)
                
                Text("Gen \(member.generation)")
                    .font(.caption2)
                    .foregroundColor(JKT48Colors.secondaryLabel)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(JKT48Colors.cardBackgroundSecondary(for: colorScheme))
        )
    }
}

struct QuickActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    @State private var isPressed = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(JKT48Colors.primaryLabel)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(JKT48Colors.secondaryLabel)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(JKT48Colors.cardBackgroundSecondary(for: colorScheme))
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .pressEvents(
            onPress: { isPressed = true },
            onRelease: { isPressed = false }
        )
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}

struct ModernSettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(JKT48Colors.primaryLabel)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(JKT48Colors.secondaryLabel)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(JKT48Colors.tertiaryLabel)
            }
            .padding(.vertical, 8)
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .pressEvents(
            onPress: { isPressed = true },
            onRelease: { isPressed = false }
        )
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}

#Preview {
    ProfileView()
        .modelContainer(for: User.self, inMemory: true)
        .environmentObject(ThemeManager())
}
