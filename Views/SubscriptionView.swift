//
//  SubscriptionView.swift
//  AtomicApplication
//
//  Created by Hillary Abigail on 18/07/25.
//

import SwiftUI
import SwiftData

struct SubscriptionView: View {
    let member: JKT48Member
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext
    @State private var selectedPlan: SubscriptionType = .basic
    @State private var showingPayment = false
    @State private var isProcessingPayment = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Member info
                    memberInfoSection
                    
                    // Subscription plans
                    subscriptionPlansSection
                    
                    // Benefits
                    benefitsSection
                    
                    // Subscribe button
                    subscribeButtonSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            .background(JKT48Colors.groupedBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Tutup") {
                        dismiss()
                    }
                    .foregroundColor(JKT48Colors.primaryPink)
                }
            }
        }
        .sheet(isPresented: $showingPayment) {
            PaymentView(member: member, subscriptionType: selectedPlan)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(JKT48Colors.lightPink)
                .frame(width: 80, height: 80)
                .overlay(
                    Text(member.nickname.prefix(1))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(JKT48Colors.primaryPink)
                )
            
            VStack(spacing: 8) {
                Text("Berlangganan \(member.nickname)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(JKT48Colors.primaryLabel)
                
                Text("Dapatkan akses eksklusif ke pesan dan konten pribadi")
                    .font(.subheadline)
                    .foregroundColor(JKT48Colors.secondaryLabel)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 20)
    }
    
    private var memberInfoSection: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(member.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(JKT48Colors.primaryLabel)
                
                Text("\(member.team) • \(member.generation)")
                    .font(.subheadline)
                    .foregroundColor(JKT48Colors.secondaryLabel)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(member.subscriberCount.formatted())")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(JKT48Colors.primaryPink)
                
                Text("subscribers")
                    .font(.caption)
                    .foregroundColor(JKT48Colors.secondaryLabel)
            }
        }
        .padding(16)
        .jkt48Card()
    }
    
    private var subscriptionPlansSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pilih Paket Langganan")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(JKT48Colors.primaryLabel)
            
            VStack(spacing: 12) {
                SubscriptionPlanCard(
                    type: .basic,
                    isSelected: selectedPlan == .basic,
                    onSelect: { selectedPlan = .basic }
                )
                
                SubscriptionPlanCard(
                    type: .premium,
                    isSelected: selectedPlan == .premium,
                    onSelect: { selectedPlan = .premium }
                )
                
                SubscriptionPlanCard(
                    type: .ultimate,
                    isSelected: selectedPlan == .ultimate,
                    onSelect: { selectedPlan = .ultimate }
                )
            }
        }
    }
    
    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Yang Akan Kamu Dapatkan")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(JKT48Colors.primaryLabel)
            
            VStack(spacing: 12) {
                BenefitRow(icon: "message.fill", title: "Pesan Pribadi", description: "Chat langsung dengan \(member.nickname)")
                BenefitRow(icon: "photo.fill", title: "Foto Eksklusif", description: "Akses ke galeri foto dan video pribadi")
                BenefitRow(icon: "mic.fill", title: "Voice Message", description: "Terima pesan suara dari \(member.nickname)")
                BenefitRow(icon: "video.fill", title: "Video Call", description: "Kesempatan video call eksklusif")
                BenefitRow(icon: "heart.fill", title: "Behind The Scene", description: "Konten backstage dan daily life")
            }
            .padding(16)
            .jkt48Card()
        }
    }
    
    private var subscribeButtonSection: some View {
        VStack(spacing: 16) {
            Button(action: { showingPayment = true }) {
                HStack {
                    if isProcessingPayment {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    }
                    
                    Text(isProcessingPayment ? "Memproses..." : "Berlangganan Sekarang")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundColor(.white)
                .background(JKT48Colors.primaryPink)
                .cornerRadius(25)
            }
            .disabled(isProcessingPayment)
            
            Text("Rp \(selectedPlan.price.formatted())/bulan • Bisa dibatalkan kapan saja")
                .font(.caption)
                .foregroundColor(JKT48Colors.secondaryLabel)
                .multilineTextAlignment(.center)
        }
    }
}

struct SubscriptionPlanCard: View {
    let type: SubscriptionType
    let isSelected: Bool
    let onSelect: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(type.displayName)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(JKT48Colors.primaryLabel)
                        
                        if type == .premium {
                            Text("POPULAR")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(JKT48Colors.primaryPink)
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                    }
                    
                    Text("Rp \(type.price.formatted())")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(JKT48Colors.primaryPink)
                    
                    Text(planDescription(for: type))
                        .font(.subheadline)
                        .foregroundColor(JKT48Colors.secondaryLabel)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Circle()
                    .stroke(
                        isSelected ? JKT48Colors.primaryPink : JKT48Colors.tertiaryLabel,
                        lineWidth: 2
                    )
                    .fill(isSelected ? JKT48Colors.primaryPink : Color.clear)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .fill(.white)
                            .frame(width: 8, height: 8)
                            .opacity(isSelected ? 1 : 0)
                    )
            }
            .padding(16)
            .background(
                isSelected ? 
                JKT48Colors.lightPink.opacity(0.3) : 
                JKT48Colors.cardBackground(for: colorScheme)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? JKT48Colors.primaryPink : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func planDescription(for type: SubscriptionType) -> String {
        switch type {
        case .basic:
            return "Akses dasar ke pesan dan foto"
        case .premium:
            return "Semua fitur basic + voice message + prioritas chat"
        case .ultimate:
            return "Semua fitur + video call + konten eksklusif"
        }
    }
}

struct BenefitRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(JKT48Colors.primaryPink)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(JKT48Colors.primaryLabel)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(JKT48Colors.secondaryLabel)
            }
            
            Spacer()
        }
    }
}

struct PaymentView: View {
    let member: JKT48Member
    let subscriptionType: SubscriptionType
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedPaymentMethod: PaymentMethod = .creditCard
    @State private var isProcessing = false
    @State private var showingSuccess = false
    
    enum PaymentMethod: String, CaseIterable {
        case creditCard = "Credit Card"
        case gopay = "GoPay"
        case ovo = "OVO"
        case dana = "DANA"
        case bankTransfer = "Transfer Bank"
        
        var icon: String {
            switch self {
            case .creditCard: return "creditcard.fill"
            case .gopay: return "g.circle.fill"
            case .ovo: return "o.circle.fill"
            case .dana: return "d.circle.fill"
            case .bankTransfer: return "building.columns.fill"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Order summary
                    orderSummarySection
                    
                    // Payment methods
                    paymentMethodsSection
                    
                    // Pay button
                    payButtonSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            .background(JKT48Colors.groupedBackground)
            .navigationTitle("Pembayaran")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Batal") {
                        dismiss()
                    }
                    .foregroundColor(JKT48Colors.primaryPink)
                }
            }
        }
        .alert("Pembayaran Berhasil!", isPresented: $showingSuccess) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Selamat! Kamu sudah berlangganan \(member.nickname). Mulai chat sekarang!")
        }
    }
    
    private var orderSummarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ringkasan Pesanan")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(JKT48Colors.primaryLabel)
            
            HStack {
                Circle()
                    .fill(JKT48Colors.lightPink)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(member.nickname.prefix(1))
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(JKT48Colors.primaryPink)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Langganan \(member.nickname)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(JKT48Colors.primaryLabel)
                    
                    Text("Paket \(subscriptionType.displayName)")
                        .font(.caption)
                        .foregroundColor(JKT48Colors.secondaryLabel)
                }
                
                Spacer()
                
                Text("Rp \(subscriptionType.price.formatted())")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(JKT48Colors.primaryPink)
            }
        }
        .padding(16)
        .jkt48Card()
    }
    
    private var paymentMethodsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Metode Pembayaran")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(JKT48Colors.primaryLabel)
            
            VStack(spacing: 8) {
                ForEach(PaymentMethod.allCases, id: \.self) { method in
                    PaymentMethodRow(
                        method: method,
                        isSelected: selectedPaymentMethod == method,
                        onSelect: { selectedPaymentMethod = method }
                    )
                }
            }
        }
    }
    
    private var payButtonSection: some View {
        VStack(spacing: 16) {
            Button(action: processPayment) {
                HStack {
                    if isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    }
                    
                    Text(isProcessing ? "Memproses Pembayaran..." : "Bayar Sekarang")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundColor(.white)
                .background(JKT48Colors.primaryPink)
                .cornerRadius(25)
            }
            .disabled(isProcessing)
            
            Text("Pembayaran aman dan terenkripsi")
                .font(.caption)
                .foregroundColor(JKT48Colors.secondaryLabel)
        }
    }
    
    private func processPayment() {
        isProcessing = true
        
        // Simulate payment processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isProcessing = false
            showingSuccess = true
            
            // Update member subscription status
            // This would normally be done on the server
            // member.isSubscribed = true
        }
    }
}

struct PaymentMethodRow: View {
    let method: PaymentView.PaymentMethod
    let isSelected: Bool
    let onSelect: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                Image(systemName: method.icon)
                    .foregroundColor(JKT48Colors.primaryPink)
                    .frame(width: 24)
                
                Text(method.rawValue)
                    .font(.subheadline)
                    .foregroundColor(JKT48Colors.primaryLabel)
                
                Spacer()
                
                Circle()
                    .stroke(
                        isSelected ? JKT48Colors.primaryPink : JKT48Colors.tertiaryLabel,
                        lineWidth: 2
                    )
                    .fill(isSelected ? JKT48Colors.primaryPink : Color.clear)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .fill(.white)
                            .frame(width: 6, height: 6)
                            .opacity(isSelected ? 1 : 0)
                    )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(JKT48Colors.cardBackground(for: colorScheme))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}