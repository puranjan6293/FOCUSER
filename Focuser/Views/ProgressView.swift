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
            ScrollView {
                VStack(spacing: 24) {
                    // Hero Section
                    ZStack {
                        LinearGradient(
                            colors: Color.successGradient + [Color.green.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )

                        VStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 100, height: 100)

                                Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                            }

                            VStack(spacing: 8) {
                                Text("Your Journey")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)

                                Text("Every victory makes you stronger")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.95))
                            }
                        }
                        .padding(.vertical, 40)
                    }
                    .cornerRadius(28)
                    .shadow(color: Color.green.opacity(0.3), radius: 20, y: 10)
                    .padding(.horizontal)

                    VStack(spacing: 16) {
                        ProgressCard(
                            title: "Days Clean",
                            value: "\(statisticsManager.daysClean)",
                            unit: "days",
                            icon: "calendar.badge.checkmark",
                            color: .blue,
                            description: "Since you started"
                        )

                        ProgressCard(
                            title: "Times Resisted",
                            value: "\(statisticsManager.statistics.manualResists)",
                            unit: "victories",
                            icon: "hand.raised.fill",
                            color: .green,
                            description: "Urges you conquered"
                        )

                        ProgressCard(
                            title: "Sites Protected",
                            value: "\(blocklistManager.blockedSites.count)",
                            unit: "domains",
                            icon: "shield.fill",
                            color: .orange,
                            description: "Blocked in Safari"
                        )

                        ProgressCard(
                            title: "Daily Average",
                            value: String(format: "%.1f", dailyAverage),
                            unit: "check-ins",
                            icon: "chart.line.uptrend.xyaxis",
                            color: .purple,
                            description: "Your consistency"
                        )
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color.purple.opacity(0.15))
                                    .frame(width: 40, height: 40)

                                Image(systemName: "trophy.fill")
                                    .font(.title3)
                                    .foregroundColor(.purple)
                            }

                            Text("Milestones")
                                .font(.headline)
                                .fontWeight(.semibold)

                            Spacer()
                        }

                        VStack(spacing: 12) {
                            MilestoneRow(title: "First Day", days: "1 day", achieved: statisticsManager.daysClean >= 1, index: 0)
                            MilestoneRow(title: "One Week Clean", days: "7 days", achieved: statisticsManager.daysClean >= 7, index: 1)
                            MilestoneRow(title: "Two Weeks Strong", days: "14 days", achieved: statisticsManager.daysClean >= 14, index: 2)
                            MilestoneRow(title: "One Month Champion", days: "30 days", achieved: statisticsManager.daysClean >= 30, index: 3)
                            MilestoneRow(title: "90-Day Warrior", days: "90 days", achieved: statisticsManager.daysClean >= 90, index: 4)
                            MilestoneRow(title: "Half Year Hero", days: "180 days", achieved: statisticsManager.daysClean >= 180, index: 5)
                            MilestoneRow(title: "One Year Legend", days: "365 days", achieved: statisticsManager.daysClean >= 365, index: 6)
                        }
                    }
                    .padding(24)
                    .glassCard(cornerRadius: 20)
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
                .padding(.top)
            }
            .navigationTitle("Progress")
        }
    }

    private var dailyAverage: Double {
        guard statisticsManager.daysClean > 0 else { return 0 }
        let total = Double(statisticsManager.statistics.manualResists)
        let days = Double(max(1, statisticsManager.daysClean))
        return total / days
    }
}

struct ProgressCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    let description: String
    @State private var isAnimated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 56, height: 56)

                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(value)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [color, color.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Text(unit)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineSpacing(2)
            }
        }
        .padding(24)
        .glassCard(cornerRadius: 20)
        .scaleEffect(isAnimated ? 1.0 : 0.9)
        .opacity(isAnimated ? 1.0 : 0)
        .onAppear {
            withAnimation(.smooth.delay(Double.random(in: 0...0.4))) {
                isAnimated = true
            }
        }
    }
}

struct MilestoneRow: View {
    let title: String
    let days: String
    let achieved: Bool
    let index: Int
    @State private var isAnimated = false

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(achieved ? Color.green.opacity(0.15) : Color.gray.opacity(0.1))
                    .frame(width: 44, height: 44)

                if achieved {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                } else {
                    Image(systemName: "lock.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.title3)
                }
            }
            .scaleEffect(isAnimated ? 1.0 : 0.5)
            .animation(.bouncy.delay(Double(index) * 0.1), value: isAnimated)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(achieved ? .primary : .secondary)

                Text(days)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if achieved {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.title3)
                    .rotationEffect(.degrees(isAnimated ? 0 : 180))
                    .animation(.bouncy.delay(Double(index) * 0.1 + 0.2), value: isAnimated)
            }
        }
        .padding(.vertical, 8)
        .onAppear {
            isAnimated = true
        }
    }
}
