//
//  MembersView.swift
//  AtomicApplication
//
//  Created by Hillary Abigail on 18/07/25.
//

import SwiftUI
import SwiftData

struct MembersView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var themeManager: ThemeManager
    @Query private var members: [JKT48Member]
    @State private var searchText = ""
    @State private var selectedTeam = "Semua"
    
    let teams = ["Semua", "Team KIII", "Team J", "Team T"]
    
    var filteredMembers: [JKT48Member] {
        var filtered = members
        
        if selectedTeam != "Semua" {
            filtered = filtered.filter { $0.team == selectedTeam }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { member in
                member.name.localizedCaseInsensitiveContains(searchText) ||
                member.nickname.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.sorted { $0.name < $1.name }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Header
                headerSection
                
                // Search and Filter
                searchFilterSection
                
                // Members Grid
                membersGridSection
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
                Text("Member JKT48")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(JKT48Colors.pinkGradient)
                
                Text("\(filteredMembers.count) member tersedia")
                    .font(.subheadline)
                    .foregroundColor(JKT48Colors.secondaryLabel)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .font(.title2)
                    .foregroundColor(JKT48Colors.primaryPink)
            }
        }
        .padding(.top, 50)
        .padding(.bottom, 20)
    }
    
    private var searchFilterSection: some View {
        VStack(spacing: 12) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(JKT48Colors.tertiaryLabel)
                
                TextField("Cari member...", text: $searchText)
                    .foregroundColor(JKT48Colors.primaryLabel)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(JKT48Colors.tertiaryLabel)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(JKT48Colors.cardBackground(for: colorScheme))
            .cornerRadius(12)
            
            // Team Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(teams, id: \.self) { team in
                        TeamFilterChip(
                            title: team,
                            isSelected: selectedTeam == team,
                            action: { selectedTeam = team }
                        )
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private var membersGridSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 16) {
            ForEach(filteredMembers) { member in
                MemberCard(member: member)
            }
        }
    }
}

struct TeamFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : JKT48Colors.primaryPink)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? JKT48Colors.primaryPink : JKT48Colors.cardBackground(for: colorScheme)
                )
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(JKT48Colors.primaryPink, lineWidth: isSelected ? 0 : 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MemberCard: View {
    let member: JKT48Member
    @Environment(\.colorScheme) var colorScheme
    @State private var showingMemberDetail = false
    
    var body: some View {
        Button(action: { showingMemberDetail = true }) {
            VStack(spacing: 12) {
                // Profile Image
                ZStack {
                    Circle()
                        .fill(JKT48Colors.lightPink)
                        .frame(width: 80, height: 80)
                    
                    Text(member.nickname.prefix(1))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(JKT48Colors.primaryPink)
                    
                    if member.isOnline {
                        Circle()
                            .fill(JKT48Colors.systemGreen)
                            .frame(width: 16, height: 16)
                            .overlay(
                                Circle()
                                    .stroke(JKT48Colors.cardBackground(for: colorScheme), lineWidth: 2)
                            )
                            .offset(x: 28, y: 28)
                    }
                }
                
                VStack(spacing: 4) {
                    Text(member.nickname)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(JKT48Colors.primaryLabel)
                        .lineLimit(1)
                    
                    Text(member.team)
                        .font(.caption)
                        .foregroundColor(JKT48Colors.secondaryLabel)
                        .lineLimit(1)
                    
                    Text("\(member.subscriberCount.formatted()) subscribers")
                        .font(.caption2)
                        .foregroundColor(JKT48Colors.tertiaryLabel)
                }
                
                // Subscribe Button
                Button(action: {}) {
                    Text(member.isSubscribed ? "Subscribed" : "Subscribe")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(member.isSubscribed ? JKT48Colors.primaryLabel : .white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            member.isSubscribed ? 
                            JKT48Colors.cardBackground(for: colorScheme) : 
                            JKT48Colors.primaryPink
                        )
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(JKT48Colors.primaryPink, lineWidth: member.isSubscribed ? 1 : 0)
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .jkt48Card()
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingMemberDetail) {
            MemberDetailView(member: member)
        }
    }
}