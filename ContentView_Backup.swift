//
//  ContentView_Backup.swift
//  AtomicApplication
//
//  Created by Hillary Abigail on 18/07/25.
//

import SwiftUI
import SwiftData

// This is a backup of the original ContentView
// Rename this back to ContentView.swift if needed

struct ContentView_Backup: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Main Dashboard
            NavigationView {
                DashboardView_Backup()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
            
            // Account Management
            AccountView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Account")
                }
                .tag(1)
            
            // Original Items View (for reference)
            NavigationSplitView {
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        } label: {
                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
                .navigationTitle("Items")
            } detail: {
                Text("Select an item")
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Items")
            }
            .tag(2)
        }
        .accentColor(.blue)
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

struct DashboardView_Backup: View {
    @State private var animateWelcome = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Welcome Header
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Welcome Back!")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Manage your account with ease")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "bell.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                    .opacity(animateWelcome ? 1.0 : 0.0)
                    .offset(x: animateWelcome ? 0 : -30)
                }
                .padding()
                
                // Quick Stats
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    StatCard_Backup(
                        title: "Account Status",
                        value: "Active",
                        icon: "checkmark.circle.fill",
                        color: .green
                    )
                    
                    StatCard_Backup(
                        title: "Security",
                        value: "Protected",
                        icon: "shield.fill",
                        color: .blue
                    )
                    
                    StatCard_Backup(
                        title: "Last Login",
                        value: "Today",
                        icon: "clock.fill",
                        color: .orange
                    )
                    
                    StatCard_Backup(
                        title: "Data Usage",
                        value: "12.5 MB",
                        icon: "chart.bar.fill",
                        color: .purple
                    )
                }
                .padding(.horizontal)
                
                // Recent Activity
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Recent Activity")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                        Button("View All") {}
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    
                    VStack(spacing: 12) {
                        ActivityRow_Backup(
                            icon: "person.circle.fill",
                            title: "Profile Updated",
                            time: "2 hours ago",
                            color: .blue
                        )
                        
                        ActivityRow_Backup(
                            icon: "lock.fill",
                            title: "Password Changed",
                            time: "1 day ago",
                            color: .green
                        )
                        
                        ActivityRow_Backup(
                            icon: "bell.fill",
                            title: "Notifications Enabled",
                            time: "3 days ago",
                            color: .orange
                        )
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .padding(.horizontal)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                animateWelcome = true
            }
        }
    }
}

struct StatCard_Backup: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(value)
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                
                HStack {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct ActivityRow_Backup: View {
    let icon: String
    let title: String
    let time: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 16))
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}