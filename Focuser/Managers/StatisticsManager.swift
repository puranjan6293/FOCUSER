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
    private let defaults = UserDefaults(suiteName: "group.com.puranjanics.Focuser") ?? .standard

    init() {
        if let data = defaults.data(forKey: statisticsKey),
           let decoded = try? JSONDecoder().decode(Statistics.self, from: data) {
            self.statistics = decoded
        } else {
            self.statistics = Statistics()
        }
    }

    func recordResist() {
        statistics.recordResist()
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

    var daysClean: Int {
        statistics.daysClean
    }

    var todayCheckIns: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: Date())
        return statistics.dailyCheckIns[today] ?? 0
    }
}
