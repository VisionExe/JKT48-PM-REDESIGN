//
//  SettingsView.swift
//  AtomicApplication
//
//  Created by Hillary Abigail on 18/07/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var themeManager: ThemeManager
    @State private var notificationsEnabled = true
    @State private var faceIDEnabled = true
    @State private var emailNotifications = true
    @State private var pushNotifications = true
    @State private var showingResetPassword = false
    @State private var showingDeleteAccount = false
    
    var body: some View {
        NavigationStack {
            List {
                // Appearance Section
                Section("Tampilan") {
                    HStack {
                        Image(systemName: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(JKT48Colors.primaryPink)
                            .frame(width: 24)
                        
                        Text("Mode Gelap")
                            .foregroundColor(JKT48Colors.primaryLabel)
                        
                        Spacer()
                        
                        Toggle("", isOn: $themeManager.isDarkMode)
                            .labelsHidden()
                    }
                    
                    JKT48SettingsRow(
                        icon: "textformat.size",
                        title: "Ukuran Teks",
                        subtitle: "Standar",
                        color: JKT48Colors.systemPurple,
                        action: { /* Text size settings */ }
                    )
                    
                    JKT48SettingsRow(
                        icon: "accessibility",
                        title: "Aksesibilitas",
                        subtitle: "Pengaturan kemudahan akses",
                        color: JKT48Colors.systemGreen,
                        action: { /* Accessibility settings */ }
                    )
                }
                
                // Security Section
                Section("Keamanan & Privasi") {
                    HStack {
                        Image(systemName: "faceid")
                            .foregroundColor(JKT48Colors.primaryPink)
                            .frame(width: 24)
                        
                        Text("Face ID / Touch ID")
                            .foregroundColor(JKT48Colors.primaryLabel)
                        
                        Spacer()
                        
                        Toggle("", isOn: $faceIDEnabled)
                            .labelsHidden()
                    }
                    
                    JKT48SettingsRow(
                        icon: "key",
                        title: "Ubah Password",
                        subtitle: "Perbarui password login",
                        color: JKT48Colors.systemRed,
                        action: { showingResetPassword = true }
                    )
                    
                    JKT48SettingsRow(
                        icon: "eye.slash",
                        title: "Pengaturan Privasi",
                        subtitle: "Kelola data dan berbagi",
                        color: JKT48Colors.systemPurple,
                        action: { /* Privacy settings */ }
                    )
                    
                    JKT48SettingsRow(
                        icon: "lock.doc",
                        title: "Autentikasi Dua Faktor",
                        subtitle: "Lapisan keamanan tambahan",
                        color: JKT48Colors.systemOrange,
                        action: { /* 2FA settings */ }
                    )
                }
                
                // Notifications Section
                Section("Notifikasi") {
                    HStack {
                        Image(systemName: "app.badge")
                            .foregroundColor(JKT48Colors.systemRed)
                            .frame(width: 24)
                        
                        Text("Push Notification")
                            .foregroundColor(JKT48Colors.primaryLabel)
                        
                        Spacer()
                        
                        Toggle("", isOn: $pushNotifications)
                            .labelsHidden()
                    }
                    
                    HStack {
                        Image(systemName: "envelope.badge")
                            .foregroundColor(JKT48Colors.primaryPink)
                            .frame(width: 24)
                        
                        Text("Notifikasi Email")
                            .foregroundColor(JKT48Colors.primaryLabel)
                        
                        Spacer()
                        
                        Toggle("", isOn: $emailNotifications)
                            .labelsHidden()
                    }
                    
                    JKT48SettingsRow(
                        icon: "speaker.wave.3",
                        title: "Suara & Haptic",
                        subtitle: "Atur suara notifikasi",
                        color: JKT48Colors.systemGreen,
                        action: { /* Sound settings */ }
                    )
                }
                
                // JKT48 Message Section
                Section("JKT48 Message") {
                    JKT48SettingsRow(
                        icon: "heart.fill",
                        title: "Langganan Saya",
                        subtitle: "Kelola member yang diikuti",
                        color: JKT48Colors.primaryPink,
                        action: { /* Subscription management */ }
                    )
                    
                    JKT48SettingsRow(
                        icon: "creditcard",
                        title: "Metode Pembayaran",
                        subtitle: "Kelola kartu dan e-wallet",
                        color: JKT48Colors.systemBlue,
                        action: { /* Payment methods */ }
                    )
                    
                    JKT48SettingsRow(
                        icon: "chart.bar",
                        title: "Statistik Penggunaan",
                        subtitle: "Lihat aktivitas chat Anda",
                        color: JKT48Colors.systemIndigo,
                        action: { /* Usage stats */ }
                    )
                }
                
                // Support Section
                Section("Bantuan & Dukungan") {
                    JKT48SettingsRow(
                        icon: "book",
                        title: "Panduan Pengguna",
                        subtitle: "Pelajari cara menggunakan aplikasi",
                        color: JKT48Colors.systemPurple,
                        action: { /* User guide */ }
                    )
                    
                    JKT48SettingsRow(
                        icon: "envelope",
                        title: "Hubungi Dukungan",
                        subtitle: "Dapatkan bantuan dari tim kami",
                        color: JKT48Colors.systemGreen,
                        action: { /* Contact support */ }
                    )
                    
                    JKT48SettingsRow(
                        icon: "star",
                        title: "Beri Rating Aplikasi",
                        subtitle: "Bagikan feedback Anda",
                        color: JKT48Colors.systemOrange,
                        action: { /* Rate app */ }
                    )
                    
                    JKT48SettingsRow(
                        icon: "info.circle",
                        title: "Tentang",
                        subtitle: "JKT48 Message v1.0.0",
                        color: JKT48Colors.primaryPink,
                        action: { /* About */ }
                    )
                }
                
                // Danger Zone
                Section("Zona Berbahaya") {
                    JKT48SettingsRow(
                        icon: "arrow.clockwise.circle",
                        title: "Reset Semua Pengaturan",
                        subtitle: "Kembalikan ke pengaturan awal",
                        color: JKT48Colors.systemOrange,
                        action: { /* Reset settings */ }
                    )
                    
                    JKT48SettingsRow(
                        icon: "trash",
                        title: "Hapus Akun",
                        subtitle: "Hapus akun secara permanen",
                        color: JKT48Colors.systemRed,
                        action: { showingDeleteAccount = true }
                    )
                }
            }
            .navigationTitle("Pengaturan")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Selesai") {
                        dismiss()
                    }
                    .foregroundColor(JKT48Colors.primaryPink)
                }
            }
        }
        .alert("Reset Password", isPresented: $showingResetPassword) {
            Button("Batal", role: .cancel) { }
            Button("Reset", role: .destructive) { /* Reset password */ }
        } message: {
            Text("Anda akan menerima email untuk mereset password.")
        }
        .alert("Hapus Akun", isPresented: $showingDeleteAccount) {
            Button("Batal", role: .cancel) { }
            Button("Hapus", role: .destructive) { /* Delete account */ }
        } message: {
            Text("Tindakan ini tidak dapat dibatalkan. Semua data Anda akan dihapus secara permanen.")
        }
    }
}

struct JKT48SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(JKT48Colors.primaryLabel)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(JKT48Colors.secondaryLabel)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(JKT48Colors.tertiaryLabel)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
}
