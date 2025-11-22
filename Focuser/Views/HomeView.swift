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
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .environmentObject(statisticsManager)
                .environmentObject(blocklistManager)
                .environmentObject(settingsManager)
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
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showEmergency = false
    @State private var showSuccessToast = false

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Hero Section - Days Clean
                    HeroCard(daysClean: statisticsManager.daysClean)

                    // Recovery Progress Card
                    RecoveryProgressCard(
                        settings: settingsManager.settings,
                        daysClean: statisticsManager.daysClean
                    )

                    // Stats Overview
                    StatsOverviewCard(
                        resists: statisticsManager.statistics.manualResists,
                        blockedSites: blocklistManager.blockedSites.count,
                        streak: statisticsManager.daysClean
                    )

                    // Motivational Quote
                    QuoteCard(daysClean: statisticsManager.daysClean)

                    // Action Buttons
                    VStack(spacing: 16) {
                        // Resist Button
                        Button(action: {
                            Haptics.success()
                            withAnimation(.spring(response: 0.3)) {
                                statisticsManager.recordResist()
                                showSuccessToast = true
                            }

                            // Auto-hide toast after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.spring(response: 0.3)) {
                                    showSuccessToast = false
                                }
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "hand.raised.fill")
                                    .font(.title3)

                                Text("I Resisted an Urge")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(
                                LinearGradient(
                                    colors: [Color(red: 0.2, green: 0.8, blue: 0.4), Color(red: 0.1, green: 0.7, blue: 0.3)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(20)
                            .shadow(color: Color(red: 0.2, green: 0.8, blue: 0.4).opacity(0.4), radius: 15, y: 8)
                        }
                        .scaleButton()

                        // Emergency Button
                        Button(action: {
                            showEmergency = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "sos.circle.fill")
                                    .font(.title3)

                                Text("Need Help Now?")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(
                                LinearGradient(
                                    colors: [Color(red: 1.0, green: 0.3, blue: 0.3), Color(red: 0.9, green: 0.2, blue: 0.2)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(20)
                            .shadow(color: Color(red: 1.0, green: 0.3, blue: 0.3).opacity(0.4), radius: 15, y: 8)
                        }
                        .scaleButton()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Focuser")
            .sheet(isPresented: $showEmergency) {
                EmergencyView()
            }
            .overlay(
                VStack {
                    if showSuccessToast {
                        SuccessToast()
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .padding(.top, 50)
                    }
                    Spacer()
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showSuccessToast)
            )
        }
    }
}

// MARK: - Success Toast
struct SuccessToast: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title2)
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 2) {
                Text("Great Job!")
                    .font(.headline)
                    .foregroundColor(.white)

                Text("Urge resisted successfully")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.2, green: 0.8, blue: 0.4), Color(red: 0.1, green: 0.7, blue: 0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: Color(red: 0.2, green: 0.8, blue: 0.4).opacity(0.4), radius: 20, y: 10)
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Hero Card
struct HeroCard: View {
    let daysClean: Int

    var body: some View {
        VStack(spacing: 16) {
            Text("\(daysClean)")
                .font(.system(size: 88, weight: .bold, design: .rounded))
                .foregroundStyle(gradientColor)

            Text(daysClean == 1 ? "Day Clean" : "Days Clean")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)

            if daysClean > 0 {
                Text(encouragementText)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 20, y: 10)
        )
    }

    var gradientColor: LinearGradient {
        if daysClean < 7 {
            return LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
        } else if daysClean < 30 {
            return LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
        } else if daysClean < 90 {
            return LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing)
        } else {
            return LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    var encouragementText: String {
        if daysClean < 3 { return "💪 Every moment counts!" }
        else if daysClean < 7 { return "🔥 You're doing amazing!" }
        else if daysClean < 14 { return "⭐️ One week strong!" }
        else if daysClean < 30 { return "🚀 You're breaking the pattern!" }
        else if daysClean < 90 { return "✨ A month clean! Incredible!" }
        else { return "👑 You're unstoppable!" }
    }
}

// MARK: - Recovery Progress Card
struct RecoveryProgressCard: View {
    let settings: UserSettings
    let daysClean: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Recovery Journey")
                        .font(.title3)
                        .fontWeight(.bold)

                    Text("\(estimatedDays) days estimated")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Circular Progress
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                        .frame(width: 60, height: 60)

                    Circle()
                        .trim(from: 0, to: progressPercentage)
                        .stroke(
                            LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))

                    Text("\(Int(progressPercentage * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }

            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.15))

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progressPercentage)
                }
            }
            .frame(height: 14)

            // Progress Text
            HStack {
                Text("\(daysClean) days")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)

                Spacer()

                Text(progressMessage)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 20, y: 10)
        )
    }

    var estimatedDays: Int {
        calculateEstimatedRecoveryDays(settings: settings)
    }

    var progressPercentage: CGFloat {
        min(CGFloat(daysClean) / CGFloat(estimatedDays), 1.0)
    }

    var progressMessage: String {
        let percentage = Int(progressPercentage * 100)
        if percentage < 25 { return "Just getting started!" }
        else if percentage < 50 { return "Making real progress!" }
        else if percentage < 75 { return "More than halfway there!" }
        else if percentage < 100 { return "Almost there!" }
        else { return "Goal achieved!" }
    }
}

// MARK: - Stats Overview Card
struct StatsOverviewCard: View {
    let resists: Int
    let blockedSites: Int
    let streak: Int

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                StatBox(
                    icon: "hand.raised.fill",
                    value: "\(resists)",
                    label: "Resisted",
                    color: Color(red: 0.2, green: 0.8, blue: 0.4)
                )

                StatBox(
                    icon: "shield.fill",
                    value: "\(blockedSites)",
                    label: "Blocked",
                    color: Color(red: 1.0, green: 0.6, blue: 0.0)
                )
            }

            HStack(spacing: 12) {
                StatBox(
                    icon: "flame.fill",
                    value: "\(streak)",
                    label: "Streak",
                    color: Color(red: 1.0, green: 0.3, blue: 0.3)
                )

                StatBox(
                    icon: "chart.line.uptrend.xyaxis",
                    value: "\(successRate)%",
                    label: "Success",
                    color: Color(red: 0.2, green: 0.6, blue: 1.0)
                )
            }
        }
    }

    var successRate: Int {
        guard streak > 0 || resists > 0 else { return 0 }
        let total = streak + resists
        return min(Int((Double(resists) / Double(total)) * 100), 100)
    }
}

struct StatBox: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 44, height: 44)

                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(color)
                }

                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 15, y: 8)
        )
    }
}

// MARK: - Quote Card
struct QuoteCard: View {
    let daysClean: Int

    let quotes = [
        "Every day clean is a victory 🏆",
        "You're stronger than you think 💪",
        "Progress, not perfection ⭐️",
        "One day at a time 🌅",
        "Your future self will thank you 🙏",
        "Breaking chains, building strength 🔥",
        "Discipline equals freedom ✨",
        "Small steps, big changes 🚀"
    ]

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.pink.opacity(0.3), .purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)

                Image(systemName: "quote.bubble.fill")
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.pink, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(selectedQuote)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineSpacing(4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 20, y: 10)
        )
    }

    var selectedQuote: String {
        quotes[daysClean % quotes.count]
    }
}

// MARK: - Helper Functions
func calculateEstimatedRecoveryDays(settings: UserSettings) -> Int {
    var baseDays = 90

    let frequencyMultiplier = 1.0 + (Double(settings.dailyWatchFrequency) * 0.1)
    baseDays = Int(Double(baseDays) * frequencyMultiplier)

    let focusAdjustment = (5 - settings.focusLevel.score) * 5
    baseDays += focusAdjustment

    let urgeAdjustment = settings.urgeFrequency.score * 3
    baseDays += urgeAdjustment

    let resistanceBonus = settings.resistanceRate.score * 2
    baseDays -= resistanceBonus

    if let firstWatch = settings.firstWatchDate {
        let yearsSince = Calendar.current.dateComponents([.year], from: firstWatch, to: Date()).year ?? 0
        baseDays += min(yearsSince * 5, 30)
    }

    return max(30, min(baseDays, 365))
}

// MARK: - Legacy Support
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

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        StatItem(value: value, label: title, color: color)
    }
}
