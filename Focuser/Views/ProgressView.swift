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

    var body: some View {
        NavigationView {
            List {
                Section {
                    // Large number display
                    VStack(spacing: 16) {
                        Text("\(statisticsManager.daysClean)")
                            .font(.system(size: 72, weight: .bold, design: .rounded))
                            .foregroundColor(.blue)

                        Text(statisticsManager.daysClean == 1 ? "Day Clean" : "Days Clean")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }

                Section(header: Text("Statistics")) {
                    StatRow(label: "Times Resisted", value: "\(statisticsManager.statistics.manualResists)", color: .green)
                    StatRow(label: "Sites Protected", value: "\(blocklistManager.blockedSites.count)", color: .orange)
                    StatRow(label: "Daily Average", value: String(format: "%.1f", dailyAverage), color: .purple)
                }

                Section(header: Text("Milestones")) {
                    MilestoneItem(title: "First Day", days: 1, achieved: statisticsManager.daysClean >= 1)
                    MilestoneItem(title: "One Week", days: 7, achieved: statisticsManager.daysClean >= 7)
                    MilestoneItem(title: "Two Weeks", days: 14, achieved: statisticsManager.daysClean >= 14)
                    MilestoneItem(title: "One Month", days: 30, achieved: statisticsManager.daysClean >= 30)
                    MilestoneItem(title: "90 Days", days: 90, achieved: statisticsManager.daysClean >= 90)
                    MilestoneItem(title: "Half Year", days: 180, achieved: statisticsManager.daysClean >= 180)
                    MilestoneItem(title: "One Year", days: 365, achieved: statisticsManager.daysClean >= 365)
                }
            }
            .navigationTitle("Progress")
        }
    }

    private var dailyAverage: Double {
        guard statisticsManager.daysClean > 0 else { return 0 }
        return Double(statisticsManager.statistics.manualResists) / Double(max(1, statisticsManager.daysClean))
    }
}

struct StatRow: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Text(label)
                .font(.body)

            Spacer()

            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
    }
}

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

// Legacy support
struct ProgressCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    let description: String

    var body: some View {
        StatRow(label: title, value: value, color: color)
    }
}

struct MilestoneRow: View {
    let title: String
    let days: String
    let achieved: Bool
    let index: Int

    var body: some View {
        MilestoneItem(title: title, days: Int(days.components(separatedBy: " ").first ?? "1") ?? 1, achieved: achieved)
    }
}
