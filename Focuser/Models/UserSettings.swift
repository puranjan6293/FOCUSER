//
//  UserSettings.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import Foundation

struct UserSettings: Codable, Equatable {
    var hasCompletedOnboarding: Bool
    var enableNotifications: Bool
    var showMotivationalQuotes: Bool
    var accountabilityPartnerEmail: String?

    // Onboarding journey data
    var firstWatchDate: Date?
    var dailyWatchFrequency: Int // 0-10+ times per day
    var focusLevel: FocusLevel
    var urgeFrequency: UrgeFrequency
    var resistanceRate: ResistanceRate
    var journeyStartDate: Date?

    init() {
        self.hasCompletedOnboarding = false
        self.enableNotifications = true
        self.showMotivationalQuotes = true
        self.accountabilityPartnerEmail = nil
        self.firstWatchDate = nil
        self.dailyWatchFrequency = 0
        self.focusLevel = .moderate
        self.urgeFrequency = .moderate
        self.resistanceRate = .sometimes
        self.journeyStartDate = nil
    }
}

enum FocusLevel: String, Codable, CaseIterable {
    case veryLow = "Very Low - Can't focus at all"
    case low = "Low - Hard to concentrate"
    case moderate = "Moderate - Sometimes distracted"
    case good = "Good - Usually focused"
    case excellent = "Excellent - Highly focused"

    var score: Int {
        switch self {
        case .veryLow: return 1
        case .low: return 2
        case .moderate: return 3
        case .good: return 4
        case .excellent: return 5
        }
    }
}

enum UrgeFrequency: String, Codable, CaseIterable {
    case rare = "Rarely - Few times a week"
    case sometimes = "Sometimes - Once a day"
    case moderate = "Moderate - 2-3 times a day"
    case frequent = "Frequent - 4-6 times a day"
    case veryFrequent = "Very Frequent - 7+ times a day"

    var score: Int {
        switch self {
        case .rare: return 1
        case .sometimes: return 2
        case .moderate: return 3
        case .frequent: return 4
        case .veryFrequent: return 5
        }
    }
}

enum ResistanceRate: String, Codable, CaseIterable {
    case never = "Never - I always give in"
    case rarely = "Rarely - 1 in 10 times"
    case sometimes = "Sometimes - 3 in 10 times"
    case often = "Often - 5 in 10 times"
    case usually = "Usually - 7 in 10 times"
    case almost = "Almost Always - 9 in 10 times"

    var score: Int {
        switch self {
        case .never: return 0
        case .rarely: return 1
        case .sometimes: return 3
        case .often: return 5
        case .usually: return 7
        case .almost: return 9
        }
    }
}
