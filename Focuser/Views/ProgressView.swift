//
//  ProgressView.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var statisticsManager: StatisticsManager
    @EnvironmentObject var blocklistManager: BlocklistManager
    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    // Recovery Ring
                    RecoveryRingSection(
                        settings: settingsManager.settings,
                        daysClean: statisticsManager.daysClean
                    )
                    .padding(.top, 8)

                    // Milestones
                    MilestonesSection(daysClean: statisticsManager.daysClean)

                    // Statistics
                    StatisticsSection(
                        resists: statisticsManager.statistics.manualResists,
                        blockedSites: blocklistManager.blockedSites.count,
                        daysClean: statisticsManager.daysClean
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Recovery Ring Section
struct RecoveryRingSection: View {
    let settings: UserSettings
    let daysClean: Int

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color(.tertiarySystemGroupedBackground), lineWidth: 20)
                    .frame(width: 180, height: 180)

                // Progress circle
                Circle()
                    .trim(from: 0, to: progressPercentage)
                    .stroke(.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 180, height: 180)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1.0), value: progressPercentage)

                // Center text
                VStack(spacing: 4) {
                    Text("\(Int(progressPercentage * 100))%")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)

                    Text("Complete")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            VStack(spacing: 8) {
                Text("Recovery Journey")
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("\(daysClean) of \(estimatedDays) days")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }

    var estimatedDays: Int {
        calculateEstimatedRecoveryDays(settings: settings)
    }

    var progressPercentage: CGFloat {
        min(CGFloat(daysClean) / CGFloat(estimatedDays), 1.0)
    }
}

// MARK: - Milestones Section
struct MilestonesSection: View {
    let daysClean: Int

    let milestones = [
        (days: 1, label: "First Day", icon: "1.circle.fill"),
        (days: 7, label: "One Week", icon: "7.circle.fill"),
        (days: 14, label: "Two Weeks", icon: "14.circle.fill"),
        (days: 30, label: "One Month", icon: "star.circle.fill"),
        (days: 90, label: "Three Months", icon: "crown.fill"),
        (days: 180, label: "Six Months", icon: "trophy.fill"),
        (days: 365, label: "One Year", icon: "medal.fill")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Milestones")
                .font(.headline)
                .foregroundColor(.primary)

            VStack(spacing: 12) {
                ForEach(milestones, id: \.days) { milestone in
                    MilestoneItemRow(
                        label: milestone.label,
                        days: milestone.days,
                        icon: milestone.icon,
                        isAchieved: daysClean >= milestone.days,
                        progress: min(CGFloat(daysClean) / CGFloat(milestone.days), 1.0)
                    )
                }
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct MilestoneItemRow: View {
    let label: String
    let days: Int
    let icon: String
    let isAchieved: Bool
    let progress: CGFloat

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(isAchieved ? .green : Color(.tertiarySystemGroupedBackground))
                    .frame(width: 40, height: 40)

                if isAchieved {
                    Image(systemName: icon)
                        .font(.body)
                        .foregroundColor(.white)
                } else {
                    Text("\(days)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
            }

            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(isAchieved ? .primary : .secondary)

                if !isAchieved {
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.tertiarySystemGroupedBackground))

                            RoundedRectangle(cornerRadius: 4)
                                .fill(.blue)
                                .frame(width: geometry.size.width * progress)
                        }
                    }
                    .frame(height: 6)
                }
            }

            Spacer()

            // Checkmark
            if isAchieved {
                Image(systemName: "checkmark")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Statistics Section
struct StatisticsSection: View {
    let resists: Int
    let blockedSites: Int
    let daysClean: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Statistics")
                .font(.headline)
                .foregroundColor(.primary)

            VStack(spacing: 12) {
                StatRow(
                    label: "Times Resisted",
                    value: "\(resists)",
                    icon: "hand.raised.fill",
                    color: .green
                )

                StatRow(
                    label: "Sites Blocked",
                    value: "\(blockedSites)",
                    icon: "shield.fill",
                    color: .orange
                )

                StatRow(
                    label: "Current Streak",
                    value: "\(daysClean)",
                    icon: "flame.fill",
                    color: .red
                )

                StatRow(
                    label: "Daily Average",
                    value: String(format: "%.1f", dailyAverage),
                    icon: "chart.line.uptrend.xyaxis",
                    color: .blue
                )
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    var dailyAverage: Double {
        guard daysClean > 0 else { return 0 }
        return Double(resists) / Double(max(1, daysClean))
    }
}

struct StatRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 32)

            Text(label)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()

            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Legacy Support
struct MilestoneItem: View {
    let title: String
    let days: Int
    let achieved: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: achieved ? "checkmark.circle.fill" : "circle")
                .foregroundColor(achieved ? .green : .secondary)
                .font(.title3)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .foregroundColor(achieved ? .primary : .secondary)

                Text("\(days) \(days == 1 ? "day" : "days")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if achieved {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.body)
            }
        }
    }
}

struct ProgressCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    let description: String

    var body: some View {
        StatRow(label: title, value: value, icon: icon, color: color)
    }
}
