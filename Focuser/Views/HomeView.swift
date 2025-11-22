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
    @StateObject private var screenTimeManager = ScreenTimeManager.shared
    @State private var selectedTab = 0
    @State private var showScreenTimeAuth = false

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
        .accentColor(.blue)
        .sheet(isPresented: $showScreenTimeAuth) {
            ScreenTimeAuthView(isPresented: $showScreenTimeAuth)
        }
        .onAppear {
            // Show Screen Time auth if not authorized
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if !screenTimeManager.isAuthorized && !UserDefaults.standard.bool(forKey: "hasSeenScreenTimePrompt") {
                    showScreenTimeAuth = true
                    UserDefaults.standard.set(true, forKey: "hasSeenScreenTimePrompt")
                }
            }
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
            ScrollView {
                VStack(spacing: 24) {
                    // Hero Section with Animated Progress Ring
                    ZStack {
                        Color.blue

                        VStack(spacing: 20) {
                            ZStack {
                                AnimatedProgressRing(
                                    progress: min(Double(statisticsManager.daysClean) / 90.0, 1.0),
                                    lineWidth: 12,
                                    gradient: [.white, .white.opacity(0.7)]
                                )
                                .frame(width: 180, height: 180)

                                VStack(spacing: 4) {
                                    Text("\(statisticsManager.daysClean)")
                                        .font(.system(size: 64, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)

                                    Text("days clean")
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                            }

                            if statisticsManager.daysClean > 0 {
                                Text("Keep going! You're doing amazing.")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.95))
                            } else {
                                Text("Your journey starts today!")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.95))
                            }
                        }
                        .padding(.vertical, 40)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .cornerRadius(28)
                    .shadow(color: Color.blue.opacity(0.3), radius: 20, y: 10)
                    .padding(.horizontal)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatCard(
                            title: "Sites Protected",
                            value: "\(blocklistManager.blockedSites.count)",
                            icon: "shield.fill",
                            color: .blue
                        )

                        StatCard(
                            title: "Times Resisted",
                            value: "\(statisticsManager.statistics.manualResists)",
                            icon: "hand.raised.fill",
                            color: .green
                        )

                        StatCard(
                            title: "Today's Wins",
                            value: "\(statisticsManager.todayCheckIns)",
                            icon: "checkmark.circle.fill",
                            color: .orange
                        )

                        StatCard(
                            title: "Days Active",
                            value: "\(statisticsManager.daysClean)",
                            icon: "calendar.badge.checkmark",
                            color: .purple
                        )
                    }
                    .padding(.horizontal)

                    Button(action: {
                        withAnimation(.bouncy) {
                            statisticsManager.recordResist()
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "hand.raised.fill")
                                .font(.title3)
                            Text("I Resisted an Urge")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            LinearGradient(
                                colors: Color.successGradient,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(18)
                        .shadow(color: Color.green.opacity(0.3), radius: 15, y: 8)
                    }
                    .scaleButton()
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color.yellow.opacity(0.15))
                                    .frame(width: 40, height: 40)

                                Image(systemName: "sparkles")
                                    .font(.title3)
                                    .foregroundColor(.yellow)
                            }

                            Text("Daily Motivation")
                                .font(.headline)
                                .fontWeight(.semibold)

                            Spacer()
                        }

                        Text(motivationalQuotes.randomElement() ?? "Stay strong!")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .italic()
                            .lineSpacing(4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(24)
                    .glassCard(cornerRadius: 20)
                    .padding(.horizontal)

                    Button(action: {
                        showEmergency = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.title3)
                            Text("Need Help Now?")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            LinearGradient(
                                colors: Color.dangerGradient,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(18)
                        .shadow(color: Color.red.opacity(0.3), radius: 15, y: 8)
                    }
                    .scaleButton()
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

}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    @State private var isAnimated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 48, height: 48)

                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(color)
                }

                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 140)
        .glassCard(cornerRadius: 20)
        .scaleEffect(isAnimated ? 1.0 : 0.8)
        .opacity(isAnimated ? 1.0 : 0)
        .onAppear {
            withAnimation(.smooth.delay(Double.random(in: 0...0.3))) {
                isAnimated = true
            }
        }
    }
}
