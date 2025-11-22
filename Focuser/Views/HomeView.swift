//
//  HomeView.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var statisticsManager = StatisticsManager()
    @StateObject private var blocklistManager = BlocklistManager()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .environmentObject(statisticsManager)
                .environmentObject(blocklistManager)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            BlockedSitesView()
                .environmentObject(blocklistManager)
                .environmentObject(statisticsManager)
                .tabItem {
                    Label("Blocklist", systemImage: "shield.fill")
                }
                .tag(1)

            ProgressView()
                .environmentObject(statisticsManager)
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(2)

            SettingsView()
                .environmentObject(statisticsManager)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}

struct DashboardView: View {
    @EnvironmentObject var statisticsManager: StatisticsManager
    @EnvironmentObject var blocklistManager: BlocklistManager
    @State private var showEmergency = false

    var motivationalQuotes = [
        "Every day clean is a victory.",
        "You're stronger than your urges.",
        "Progress, not perfection.",
        "One day at a time.",
        "Your future self will thank you.",
        "You're breaking the chains.",
        "Discipline equals freedom.",
        "Small steps lead to big changes."
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text("Current Streak")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text("\(statisticsManager.streakDays)")
                                .font(.system(size: 72, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )

                            Text("days")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }

                        if statisticsManager.streakDays > 0 {
                            Text("Keep going! You're doing amazing.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .padding(.horizontal)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatCard(
                            title: "Blocked Today",
                            value: "\(todayBlocks)",
                            icon: "shield.checkmark.fill",
                            color: .green
                        )

                        StatCard(
                            title: "Total Blocks",
                            value: "\(statisticsManager.statistics.totalBlocks)",
                            icon: "checkmark.shield.fill",
                            color: .blue
                        )

                        StatCard(
                            title: "Sites Blocked",
                            value: "\(blocklistManager.blockedSites.count)",
                            icon: "list.bullet.rectangle.fill",
                            color: .orange
                        )

                        StatCard(
                            title: "Best Streak",
                            value: "\(statisticsManager.statistics.longestStreak)",
                            icon: "flame.fill",
                            color: .red
                        )
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Daily Motivation", systemImage: "sparkles")
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text(motivationalQuotes.randomElement() ?? "Stay strong!")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .padding(.horizontal)

                    Button(action: {
                        showEmergency = true
                    }) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text("Need Help Now?")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            LinearGradient(
                                colors: [.red, .orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
                .padding(.top)
            }
            .navigationTitle("Focuser")
            .sheet(isPresented: $showEmergency) {
                EmergencyView()
            }
        }
    }

    private var todayBlocks: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: Date())
        return statisticsManager.statistics.dailyBlocks[today] ?? 0
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)

                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
}
