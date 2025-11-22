//
//  Statistics.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import Foundation

struct Statistics: Codable {
    var manualResists: Int
    var longestStreak: Int
    var startDate: Date
    var lastCheckInDate: Date?
    var dailyCheckIns: [String: Int]

    init() {
        self.manualResists = 0
        self.longestStreak = 0
        self.startDate = Date()
        self.lastCheckInDate = nil
        self.dailyCheckIns = [:]
    }

    mutating func recordResist() {
        manualResists += 1
        lastCheckInDate = Date()

        let dateKey = dateFormatter.string(from: Date())
        dailyCheckIns[dateKey, default: 0] += 1
    }

    var daysClean: Int {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: startDate, to: Date()).day ?? 0
        return max(0, days)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
