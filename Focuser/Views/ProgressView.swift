//
//  ProgressView.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var statisticsManager: StatisticsManager

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text("Your Journey")
                            .font(.title)
                            .fontWeight(.bold)

                        Text("Every block is a step forward")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 32)

                    VStack(spacing: 16) {
                        ProgressCard(
                            title: "Current Streak",
                            value: "\(statisticsManager.streakDays)",
                            unit: "days",
                            icon: "flame.fill",
                            color: .orange,
                            description: "Keep the momentum going!"
                        )

                        ProgressCard(
                            title: "Longest Streak",
                            value: "\(statisticsManager.statistics.longestStreak)",
                            unit: "days",
                            icon: "trophy.fill",
                            color: .yellow,
                            description: "Your personal record"
                        )

                        ProgressCard(
                            title: "Total Blocks",
                            value: "\(statisticsManager.statistics.totalBlocks)",
                            unit: "attempts",
                            icon: "shield.checkmark.fill",
                            color: .green,
                            description: "Temptations resisted"
                        )

                        ProgressCard(
                            title: "Days Active",
                            value: "\(daysActive)",
                            unit: "days",
                            icon: "calendar.badge.checkmark",
                            color: .blue,
                            description: "Since you started"
                        )
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Milestones")
                            .font(.headline)

                        VStack(spacing: 12) {
                            MilestoneRow(title: "First Day", achieved: statisticsManager.streakDays >= 1)
                            MilestoneRow(title: "One Week Clean", achieved: statisticsManager.streakDays >= 7)
                            MilestoneRow(title: "Two Weeks Strong", achieved: statisticsManager.streakDays >= 14)
                            MilestoneRow(title: "One Month Champion", achieved: statisticsManager.streakDays >= 30)
                            MilestoneRow(title: "90-Day Warrior", achieved: statisticsManager.streakDays >= 90)
                            MilestoneRow(title: "Half Year Hero", achieved: statisticsManager.streakDays >= 180)
                            MilestoneRow(title: "One Year Legend", achieved: statisticsManager.streakDays >= 365)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
                .padding(.top)
            }
            .navigationTitle("Progress")
        }
    }

    private var daysActive: Int {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: statisticsManager.statistics.streakStartDate, to: Date()).day ?? 0
        return max(1, days)
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
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)

                Spacer()

                VStack(alignment: .trailing, spacing: 0) {
                    Text(value)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(color)

                    Text(unit)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

struct MilestoneRow: View {
    let title: String
    let achieved: Bool

    var body: some View {
        HStack {
            Image(systemName: achieved ? "checkmark.circle.fill" : "circle")
                .foregroundColor(achieved ? .green : .secondary)
                .font(.title3)

            Text(title)
                .font(.body)
                .foregroundColor(achieved ? .primary : .secondary)

            Spacer()

            if achieved {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
}
