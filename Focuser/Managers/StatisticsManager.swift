//
//  StatisticsManager.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import Foundation
import Combine

class StatisticsManager: ObservableObject {
    @Published var statistics: Statistics

    private let statisticsKey = "user_statistics"
    private let defaults = UserDefaults(suiteName: "group.com.focuser.app") ?? .standard

    init() {
        if let data = defaults.data(forKey: statisticsKey),
           let decoded = try? JSONDecoder().decode(Statistics.self, from: data) {
            self.statistics = decoded
        } else {
            self.statistics = Statistics()
        }
    }

    func recordBlock() {
        statistics.recordBlock()
        statistics.updateStreak()
        save()
    }

    func resetStatistics() {
        statistics = Statistics()
        save()
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(statistics) {
            defaults.set(encoded, forKey: statisticsKey)
        }
    }

    var streakDays: Int {
        let calendar = Calendar.current
        let daysSinceStart = calendar.dateComponents([.day], from: statistics.streakStartDate, to: Date()).day ?? 0
        return max(daysSinceStart, statistics.currentStreak)
    }
}
