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

    init() {
        self.hasCompletedOnboarding = false
        self.enableNotifications = true
        self.showMotivationalQuotes = true
        self.accountabilityPartnerEmail = nil
    }
}
