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
                .environmentObject(blocklistManager)
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
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    // Large Days Counter - Hero
                    VStack(spacing: 12) {
                        Text("\(statisticsManager.daysClean)")
                            .font(.system(size: 96, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .blue.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text(statisticsManager.daysClean == 1 ? "Day Clean" : "Days Clean")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)

                        if statisticsManager.daysClean > 0 {
                            Text("Keep going")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)

                    // Simple Stats Grid - No cards, just clean layout
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            StatItem(
                                value: "\(statisticsManager.statistics.manualResists)",
                                label: "Resisted",
                                color: .green
                            )

                            Divider()
                                .frame(height: 40)

                            StatItem(
                                value: "\(blocklistManager.blockedSites.count)",
                                label: "Sites Blocked",
                                color: .orange
                            )
                        }
                        .padding(.horizontal, 40)
                    }

                    // Action Buttons - Clean, minimal
                    VStack(spacing: 12) {
                        Button(action: {
                            Haptics.success()
                            withAnimation(.spring(response: 0.3)) {
                                statisticsManager.recordResist()
                            }
                        }) {
                            Text("I Resisted an Urge")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.green)
                                .cornerRadius(16)
                        }
                        .scaleButton()

                        Button(action: {
                            showEmergency = true
                        }) {
                            Text("Need Help Now?")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.red)
                                .cornerRadius(16)
                        }
                        .scaleButton()
                    }
                    .padding(.horizontal, 20)

                    // Simple Quote - No card
                    VStack(spacing: 8) {
                        Text(motivationalQuotes.randomElement() ?? "Stay strong!")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    .padding(.vertical, 20)
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("Focuser")
            .sheet(isPresented: $showEmergency) {
                EmergencyView()
            }
        }
    }
}

// Minimal stat item - no cards
struct StatItem: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(color)

            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// Legacy support
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        StatItem(value: value, label: title, color: color)
    }
}
