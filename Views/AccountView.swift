//
//  AccountView.swift
//  AtomicApplication
//
//  Created by Hillary Abigail on 18/07/25.
//

import SwiftUI
import SwiftData

struct AccountView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var themeManager: ThemeManager
    @Query private var users: [User]
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    @State private var animateProfile = false
    @State private var animateCards = false
    @State private var scrollOffset: CGFloat = 0
    @State private var showingJKTInfo = false
    
    var currentUser: User? {
        users.first
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Ultra Modern Hero Section
                        ultraModernHeroSection
                            .frame(height: 400)
                        
                        // JKT48 Generation Cards
                        jkt48GenerationSection
                            .padding(.top, -100)
                            .zIndex(1)
                        
                        // Live Statistics Dashboard
                        liveStatsSection
                            .padding(.top, 40)
                        
                        // Modern Account Information
                        modernAccountInfoSection
                            .padding(.top, 30)
                        
                        // Premium Features
                        premiumFeaturesSection
                            .padding(.top, 20)
                            .padding(.bottom, 120)
                    }
                }
                .coordinateSpace(name: "scroll")
                .background(
                    ZStack {
                        // Dynamic gradient background
                        LinearGradient(
                            colors: [
                                JKT48Colors.primaryPink.opacity(0.15),
                                JKT48Colors.lightPink.opacity(0.08),
                                JKT48Colors.primaryPink.opacity(0.05),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        
                        // Animated blob shapes
                        ForEach(0..<8, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 50)
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            JKT48Colors.primaryPink.opacity(0.1),
                                            JKT48Colors.lightPink.opacity(0.05),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 10,
                                        endRadius: 100
                                    )
                                )
                                .frame(
                                    width: CGFloat.random(in: 80...150),
                                    height: CGFloat.random(in: 40...80)
                                )
                                .rotationEffect(.degrees(Double.random(in: 0...360)))
                                .position(
                                    x: CGFloat.random(in: 0...geometry.size.width),
                                    y: CGFloat.random(in: 0...geometry.size.height)
                                )
                                .animation(
                                    .easeInOut(duration: Double.random(in: 4...8))
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.7),
                                    value: animateProfile
                                )
                        }
                    }
                )
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(user: currentUser)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingJKTInfo) {
            JKT48InfoView()
        }
        .onAppear {
            createDemoUserIfNeeded()
            withAnimation(.spring(response: 1.5, dampingFraction: 0.7)) {
                animateProfile = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.spring(response: 1.2, dampingFraction: 0.8)) {
                    animateCards = true
                }
            }
        }
    }
    
    private var ultraModernHeroSection: some View {
        ZStack {
            // Ultra modern gradient with multiple layers
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            JKT48Colors.primaryPink,
                            JKT48Colors.darkPink,
                            Color(red: 0.9, green: 0.2, blue: 0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.2),
                            Color.clear,
                            Color.black.opacity(0.1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    // Modern mesh pattern with animation
                    Canvas { context, size in
                        let spacing: CGFloat = 25
                        let opacity = 0.15
                        
                        context.stroke(
                            Path { path in
                                // Diagonal grid pattern
                                for i in stride(from: -size.height, through: size.width + size.height, by: spacing) {
                                    path.move(to: CGPoint(x: i, y: 0))
                                    path.addLine(to: CGPoint(x: i + size.height, y: size.height))
                                }
                                for i in stride(from: 0, through: size.width + size.height, by: spacing) {
                                    path.move(to: CGPoint(x: i, y: 0))
                                    path.addLine(to: CGPoint(x: i - size.height, y: size.height))
                                }
                            },
                            with: .color(.white.opacity(opacity)),
                            lineWidth: 0.8
                        )
                    }
                )
            
            VStack(spacing: 0) {
                // Status bar spacer
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 60)
                
                // Top navigation
                HStack {
                    Button(action: { showingJKTInfo = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "info.circle.fill")
                            Text("JKT48")
                                .fontWeight(.semibold)
                        }
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(.white.opacity(0.2))
                        )
                    }
                    
                    Spacer()
                    
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(.white.opacity(0.2))
                                    .background(.ultraThinMaterial)
                            )
                    }
                }
                .padding(.horizontal, 24)
                .scaleEffect(animateProfile ? 1.0 : 0.9)
                .opacity(animateProfile ? 1.0 : 0.0)
                
                Spacer()
                
                // Ultra modern profile section
                VStack(spacing: 24) {
                    // Profile image with advanced styling
                    Button(action: { showingEditProfile = true }) {
                        ZStack {
                            // Outer glow rings (multiple layers)
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                .white.opacity(0.8 - Double(index) * 0.2),
                                                .white.opacity(0.3 - Double(index) * 0.1)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                                    .frame(
                                        width: 160 + CGFloat(index * 15),
                                        height: 160 + CGFloat(index * 15)
                                    )
                                    .blur(radius: CGFloat(3 + index * 2))
                                    .opacity(0.6 - Double(index) * 0.2)
                            }
                            
                            // Main profile container
                            Circle()
                                .fill(.white)
                                .frame(width: 150, height: 150)
                                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                            
                            if let imageData = currentUser?.profileImageData,
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 140, height: 140)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(JKT48Colors.lightPinkGradient)
                                    .frame(width: 140, height: 140)
                                    .overlay(
                                        Text(currentUser?.name.prefix(1).uppercased() ?? "H")
                                            .font(.system(size: 48, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                            }
                            
                            // Modern edit indicator
                            Circle()
                                .fill(.white)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(JKT48Colors.primaryPink)
                                )
                                .offset(x: 55, y: 55)
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        }
                    }
                    .scaleEffect(animateProfile ? 1.0 : 0.6)
                    .opacity(animateProfile ? 1.0 : 0.0)
                    .rotation3DEffect(
                        .degrees(animateProfile ? 0 : 180),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    
                    // Enhanced user info
                    VStack(spacing: 16) {
                        Text(currentUser?.name ?? "Hillary Abigail")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 12) {
                            Text(currentUser?.email ?? "hillary@jkt48.com")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                            
                            if currentUser?.isEmailVerified == true {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            }
                        }
                        
                        // Enhanced member status with generation info
                        VStack(spacing: 8) {
                            HStack(spacing: 12) {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow)
                                Text("JKT48 Premium Fan")
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(.white.opacity(0.25))
                                    .backdrop(effect: .systemUltraThinMaterial)
                            )
                            .foregroundColor(.white)
                            
                            // Generation preference
                            Text("Following Gen 12 • Active since 2024")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .offset(y: animateProfile ? 0 : 40)
                    .opacity(animateProfile ? 1.0 : 0.0)
                }
                
                Spacer()
            }
        }
    }
    
    private var jkt48GenerationSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("JKT48 Generations")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(JKT48Colors.primaryLabel)
                Spacer()
                Button("Lihat Semua") {
                    showingJKTInfo = true
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(JKT48Colors.primaryPink)
            }
            .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(jkt48Generations, id: \.id) { generation in
                        JKT48GenerationCard(
                            generation: generation,
                            isAnimated: animateCards
                        )
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    private var liveStatsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Live Statistics")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(JKT48Colors.primaryLabel)
                    
                    Text("Real-time JKT48 activity")
                        .font(.system(size: 14))
                        .foregroundColor(JKT48Colors.secondaryLabel)
                }
                Spacer()
                
                // Live indicator
                HStack(spacing: 6) {
                    Circle()
                        .fill(JKT48Colors.systemGreen)
                        .frame(width: 8, height: 8)
                        .animation(
                            .easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true),
                            value: animateProfile
                        )
                    
                    Text("LIVE")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(JKT48Colors.systemGreen)
                }
            }
            .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    UltraModernStatCard(
                        value: "2,847",
                        label: "Messages Today",
                        icon: "paperplane.fill",
                        color: JKT48Colors.primaryPink,
                        trend: .up,
                        trendValue: "+12%"
                    )
                    
                    UltraModernStatCard(
                        value: "156",
                        label: "Active Members",
                        icon: "person.3.fill",
                        color: JKT48Colors.systemBlue,
                        trend: .up,
                        trendValue: "+3"
                    )
                    
                    UltraModernStatCard(
                        value: "Gen 12",
                        label: "Latest Generation",
                        icon: "star.fill",
                        color: JKT48Colors.systemOrange,
                        trend: .neutral,
                        trendValue: "New!"
                    )
                    
                    UltraModernStatCard(
                        value: "47k",
                        label: "Global Fans",
                        icon: "heart.fill",
                        color: JKT48Colors.systemRed,
                        trend: .up,
                        trendValue: "+2.3k"
                    )
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    private var modernAccountInfoSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Account Information")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(JKT48Colors.primaryLabel)
                .padding(.horizontal, 24)
            
            VStack(spacing: 16) {
                UltraModernInfoRow(
                    icon: "phone.circle.fill",
                    title: "Phone Number",
                    value: formatPhoneNumber(currentUser?.phoneNumber ?? ""),
                    color: JKT48Colors.systemGreen,
                    hasAction: true
                )
                
                UltraModernInfoRow(
                    icon: "calendar.circle.fill",
                    title: "Member Since",
                    value: formatDate(currentUser?.createdAt ?? Date()),
                    color: JKT48Colors.systemBlue,
                    hasAction: false
                )
                
                if let lastLogin = currentUser?.lastLoginAt {
                    UltraModernInfoRow(
                        icon: "clock.arrow.circlepath",
                        title: "Last Active",
                        value: formatDateTime(lastLogin),
                        color: JKT48Colors.systemPurple,
                        hasAction: false
                    )
                }
                
                UltraModernInfoRow(
                    icon: "checkmark.seal.fill",
                    title: "Verification Status",
                    value: currentUser?.isEmailVerified == true ? "Verified Fan ✓" : "Pending Verification",
                    color: currentUser?.isEmailVerified == true ? JKT48Colors.systemGreen : JKT48Colors.systemOrange,
                    hasAction: currentUser?.isEmailVerified != true
                )
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(JKT48Colors.cardBackground(for: colorScheme))
                    .shadow(
                        color: colorScheme == .dark ? Color.clear : JKT48Colors.primaryPink.opacity(0.15),
                        radius: 20,
                        x: 0,
                        y: 10
                    )
            )
            .padding(.horizontal, 24)
        }
    }
    
    private var premiumFeaturesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Premium Features")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(JKT48Colors.primaryLabel)
                .padding(.horizontal, 24)
            
            VStack(spacing: 12) {
                PremiumFeatureRow(
                    icon: "gearshape.fill",
                    title: "Advanced Settings",
                    subtitle: "Customize your JKT48 experience",
                    color: JKT48Colors.systemBlue,
                    isPremium: true,
                    action: { showingSettings = true }
                )
                
                PremiumFeatureRow(
                    icon: "lock.shield.fill",
                    title: "Enhanced Security",
                    subtitle: "Premium protection for your account",
                    color: JKT48Colors.systemGreen,
                    isPremium: true,
                    action: { /* Security settings */ }
                )
                
                PremiumFeatureRow(
                    icon: "bell.badge.fill",
                    title: "Priority Notifications",
                    subtitle: "Get notified first about new content",
                    color: JKT48Colors.systemOrange,
                    isPremium: true,
                    action: { /* Notifications */ }
                )
                
                PremiumFeatureRow(
                    icon: "heart.text.square.fill",
                    title: "Exclusive Content",
                    subtitle: "Access to member-only messages",
                    color: JKT48Colors.primaryPink,
                    isPremium: true,
                    action: { /* Exclusive content */ }
                )
                
                PremiumFeatureRow(
                    icon: "arrow.right.square.fill",
                    title: "Sign Out",
                    subtitle: "Safely logout from your account",
                    color: JKT48Colors.systemRed,
                    isPremium: false,
                    action: { /* Sign out */ }
                )
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(JKT48Colors.cardBackground(for: colorScheme))
                    .shadow(
                        color: colorScheme == .dark ? Color.clear : JKT48Colors.primaryPink.opacity(0.15),
                        radius: 20,
                        x: 0,
                        y: 10
                    )
            )
            .padding(.horizontal, 24)
        }
    }
    
    // Helper functions and data
    private var jkt48Generations: [JKT48Generation] {
        [
            JKT48Generation(id: 12, name: "Generation 12", year: "2024", memberCount: 16, isLatest: true),
            JKT48Generation(id: 11, name: "Generation 11", year: "2023", memberCount: 18, isLatest: false),
            JKT48Generation(id: 10, name: "Generation 10", year: "2022", memberCount: 20, isLatest: false),
            JKT48Generation(id: 9, name: "Generation 9", year: "2021", memberCount: 22, isLatest: false),
        ]
    }
    
    // ...existing helper functions...
    
    private func createDemoUserIfNeeded() {
        if users.isEmpty {
            let demoUser = User(
                name: "Hillary Abigail",
                email: "hillary@jkt48.com",
                phoneNumber: "+6281234567890",
                bio: "JKT48 Premium Fan • Following Gen 12 members • iOS Developer"
            )
            demoUser.isEmailVerified = true
            demoUser.lastLoginAt = Date()
            modelContext.insert(demoUser)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: date)
    }
    
    private func formatDateTime(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        if phoneNumber.isEmpty { return "Not set" }
        if phoneNumber.hasPrefix("+62") { return phoneNumber }
        if phoneNumber.hasPrefix("08") { return "+62" + String(phoneNumber.dropFirst()) }
        if phoneNumber.hasPrefix("8") { return "+62" + phoneNumber }
        return phoneNumber
    }
}

// MARK: - Modern Components

struct JKT48Generation {
    let id: Int
    let name: String
    let year: String
    let memberCount: Int
    let isLatest: Bool
}

struct JKT48GenerationCard: View {
    let generation: JKT48Generation
    let isAnimated: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        generation.isLatest ?
                        JKT48Colors.pinkGradient :
                        JKT48Colors.cardBackground(for: colorScheme)
                    )
                    .frame(width: 120, height: 80)
                
                VStack(spacing: 4) {
                    Text("Gen \(generation.id)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(generation.isLatest ? .white : JKT48Colors.primaryLabel)
                    
                    Text("\(generation.memberCount) Members")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(generation.isLatest ? .white.opacity(0.9) : JKT48Colors.secondaryLabel)
                }
                
                if generation.isLatest {
                    VStack {
                        HStack {
                            Spacer()
                            Text("NEW")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .fill(Color.yellow)
                                )
                        }
                        Spacer()
                    }
                    .padding(8)
                }
            }
            
            VStack(spacing: 2) {
                Text(generation.year)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(JKT48Colors.primaryLabel)
                
                Text(generation.isLatest ? "Latest" : "Classic")
                    .font(.system(size: 10))
                    .foregroundColor(JKT48Colors.secondaryLabel)
            }
        }
        .scaleEffect(isAnimated ? 1.0 : 0.8)
        .opacity(isAnimated ? 1.0 : 0.0)
        .animation(
            .spring(response: 1.0, dampingFraction: 0.8)
            .delay(Double(generation.id) * 0.1),
            value: isAnimated
        )
    }
}

enum StatTrend {
    case up, down, neutral
}

struct UltraModernStatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    let trend: StatTrend
    let trendValue: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.system(size: 18, weight: .semibold))
                }
                
                Spacer()
                
                // Trend indicator
                HStack(spacing: 4) {
                    Image(systemName: trend == .up ? "arrow.up" : trend == .down ? "arrow.down" : "minus")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(trend == .up ? .green : trend == .down ? .red : .gray)
                    
                    Text(trendValue)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(trend == .up ? .green : trend == .down ? .red : .gray)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .fill((trend == .up ? Color.green : trend == .down ? Color.red : Color.gray).opacity(0.1))
                )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(JKT48Colors.primaryLabel)
                
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(JKT48Colors.secondaryLabel)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .frame(width: 160)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(JKT48Colors.cardBackground(for: colorScheme))
                .shadow(
                    color: colorScheme == .dark ? Color.clear : color.opacity(0.2),
                    radius: 12,
                    x: 0,
                    y: 6
                )
        )
    }
}

struct UltraModernInfoRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    let hasAction: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 20, weight: .semibold))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(JKT48Colors.primaryLabel)
                
                Text(value)
                    .font(.system(size: 14))
                    .foregroundColor(JKT48Colors.secondaryLabel)
            }
            
            Spacer()
            
            if hasAction {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(JKT48Colors.tertiaryLabel)
            }
        }
        .padding(.vertical, 8)
    }
}

struct PremiumFeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let isPremium: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.system(size: 20, weight: .semibold))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(JKT48Colors.primaryLabel)
                        
                        if isPremium {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 12))
                        }
                    }
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(JKT48Colors.secondaryLabel)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(JKT48Colors.tertiaryLabel)
            }
            .padding(.vertical, 12)
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

struct JKT48InfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("JKT48 Jakarta")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Sister group AKB48 di Indonesia dengan 12 generasi member aktif")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                    
                    // Generation info here
                }
                .padding()
            }
            .navigationTitle("JKT48 Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Tutup") { dismiss() }
                }
            }
        }
    }
}

// Helper extension
extension View {
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        self.simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in onPress() }
                .onEnded { _ in onRelease() }
        )
    }
}

#Preview {
    AccountView()
        .modelContainer(for: User.self, inMemory: true)
        .environmentObject(ThemeManager())
}
