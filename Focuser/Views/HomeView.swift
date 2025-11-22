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
                .environmentObject(settingsManager)
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
                VStack(spacing: 32) {
                    // Hero Timer Section
                    LiveTimerSection(startDate: statisticsManager.statistics.startDate)
                        .padding(.top, 8)

                    // Week Calendar
                    WeekCalendarSection(startDate: statisticsManager.statistics.startDate)

                    // Stats Row
                    StatsRowSection(
                        resists: statisticsManager.statistics.manualResists,
                        blockedSites: blocklistManager.blockedSites.count
                    )

                    // Recovery Progress
                    RecoverySection(
                        settings: settingsManager.settings,
                        daysClean: statisticsManager.daysClean
                    )

                    // Action Buttons
                    ActionsSection(
                        onResist: {
                            Haptics.success()
                            withAnimation(.spring(response: 0.3)) {
                                statisticsManager.recordResist()
                                showSuccessToast = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.spring(response: 0.3)) {
                                    showSuccessToast = false
                                }
                            }
                        },
                        onEmergency: { showEmergency = true }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showEmergency) {
                EmergencyView()
            }
            .overlay(alignment: .top) {
                if showSuccessToast {
                    ToastBanner()
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.top, 100)
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showSuccessToast)
        }
    }
}

// MARK: - Live Timer Section
struct LiveTimerSection: View {
    let startDate: Date
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            Text("Clean For")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.bottom, 20)

            HStack(spacing: 0) {
                TimeBlock(value: timeComponents.days, label: "d")
                TimeSeparator()
                TimeBlock(value: timeComponents.hours, label: "h")
                TimeSeparator()
                TimeBlock(value: timeComponents.minutes, label: "m")
                TimeSeparator()
                TimeBlock(value: timeComponents.seconds, label: "s")
            }
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }

    var timeComponents: (days: Int, hours: Int, minutes: Int, seconds: Int) {
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: startDate, to: currentTime)
        return (
            days: components.day ?? 0,
            hours: components.hour ?? 0,
            minutes: components.minute ?? 0,
            seconds: components.second ?? 0
        )
    }
}

struct TimeBlock: View {
    let value: Int
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .monospacedDigit()

            Text(label)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
    }
}

struct TimeSeparator: View {
    var body: some View {
        Text(":")
            .font(.system(size: 32, weight: .semibold))
            .foregroundColor(.secondary.opacity(0.5))
            .padding(.horizontal, 4)
            .offset(y: -8)
    }
}

// MARK: - Week Calendar Section
struct WeekCalendarSection: View {
    let startDate: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This Week")
                .font(.headline)
                .foregroundColor(.primary)

            HStack(spacing: 8) {
                ForEach(weekDays, id: \.day) { item in
                    WeekDayCell(
                        dayName: item.dayName,
                        dayNumber: item.dayNumber,
                        isCompleted: item.isCompleted,
                        isToday: item.isToday
                    )
                }
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    var weekDays: [(dayName: String, dayNumber: Int, day: Int, isCompleted: Bool, isToday: Bool)] {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!

        return (0..<7).map { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: startOfWeek)!
            let dayName = date.formatted(.dateTime.weekday(.narrow))
            let dayNumber = calendar.component(.day, from: date)
            let isToday = calendar.isDateInToday(date)
            let isCompleted = date < today && date >= startDate
            return (dayName: dayName, dayNumber: dayNumber, day: offset, isCompleted: isCompleted, isToday: isToday)
        }
    }
}

struct WeekDayCell: View {
    let dayName: String
    let dayNumber: Int
    let isCompleted: Bool
    let isToday: Bool

    var body: some View {
        VStack(spacing: 8) {
            Text(dayName)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)

            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 36, height: 36)

                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                } else {
                    Text("\(dayNumber)")
                        .font(.caption)
                        .fontWeight(isToday ? .bold : .medium)
                        .foregroundColor(isToday ? .white : .primary)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    var backgroundColor: Color {
        if isCompleted { return .green }
        else if isToday { return .blue }
        else { return Color(.tertiarySystemGroupedBackground) }
    }
}

// MARK: - Stats Row Section
struct StatsRowSection: View {
    let resists: Int
    let blockedSites: Int

    var body: some View {
        HStack(spacing: 12) {
            StatMiniCard(
                icon: "hand.raised.fill",
                value: "\(resists)",
                label: "Resisted",
                color: .green
            )

            StatMiniCard(
                icon: "shield.fill",
                value: "\(blockedSites)",
                label: "Blocked",
                color: .orange
            )
        }
    }
}

struct StatMiniCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Recovery Section
struct RecoverySection: View {
    let settings: UserSettings
    let daysClean: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recovery")
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()

                Text("\(daysClean)/\(estimatedDays)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }

            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.tertiarySystemGroupedBackground))

                    RoundedRectangle(cornerRadius: 8)
                        .fill(.blue)
                        .frame(width: geometry.size.width * progressPercentage)
                }
            }
            .frame(height: 12)

            Text(progressMessage)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    var estimatedDays: Int {
        calculateEstimatedRecoveryDays(settings: settings)
    }

    var progressPercentage: CGFloat {
        min(CGFloat(daysClean) / CGFloat(estimatedDays), 1.0)
    }

    var progressMessage: String {
        let percentage = Int(progressPercentage * 100)
        if percentage < 25 { return "Just getting started" }
        else if percentage < 50 { return "Making progress" }
        else if percentage < 75 { return "Over halfway there" }
        else if percentage < 100 { return "Almost complete" }
        else { return "Goal achieved!" }
    }
}

// MARK: - Actions Section
struct ActionsSection: View {
    let onResist: () -> Void
    let onEmergency: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Button(action: onResist) {
                HStack(spacing: 12) {
                    Image(systemName: "hand.raised.fill")
                        .font(.body)

                    Text("I Resisted an Urge")
                        .font(.body)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(.green)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)

            Button(action: onEmergency) {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.body)

                    Text("Need Help Now?")
                        .font(.body)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(.red)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Toast Banner
struct ToastBanner: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title3)
                .foregroundColor(.green)

            Text("Great job! Keep it up")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        )
        .padding(.horizontal, 20)
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
