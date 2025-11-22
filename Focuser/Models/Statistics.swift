//
//  Statistics.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import Foundation

struct Statistics: Codable {
    var totalBlocks: Int
    var currentStreak: Int
    var longestStreak: Int
    var lastBlockDate: Date?
    var streakStartDate: Date
    var dailyBlocks: [String: Int]

    init() {
        self.totalBlocks = 0
        self.currentStreak = 0
        self.longestStreak = 0
        self.lastBlockDate = nil
        self.streakStartDate = Date()
        self.dailyBlocks = [:]
    }

    mutating func recordBlock() {
        totalBlocks += 1
        lastBlockDate = Date()

        let dateKey = dateFormatter.string(from: Date())
        dailyBlocks[dateKey, default: 0] += 1
    }

    mutating func updateStreak() {
        guard let lastBlock = lastBlockDate else {
            currentStreak = 0
            return
        }

        let calendar = Calendar.current
        let daysSinceLastBlock = calendar.dateComponents([.day], from: lastBlock, to: Date()).day ?? 0

        if daysSinceLastBlock == 0 {
            currentStreak += 1
        } else if daysSinceLastBlock == 1 {
            currentStreak += 1
        } else {
            currentStreak = 0
            streakStartDate = Date()
        }

        if currentStreak > longestStreak {
            longestStreak = currentStreak
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
