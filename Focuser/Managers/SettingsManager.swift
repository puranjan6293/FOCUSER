//
//  SettingsManager.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import Foundation

class SettingsManager: ObservableObject {
    @Published var settings: UserSettings

    private let settingsKey = "user_settings"
    private let defaults = UserDefaults.standard

    init() {
        if let data = defaults.data(forKey: settingsKey),
           let decoded = try? JSONDecoder().decode(UserSettings.self, from: data) {
            self.settings = decoded
        } else {
            self.settings = UserSettings()
        }
    }

    func completeOnboarding() {
        settings.hasCompletedOnboarding = true
        save()
    }

    func updateSettings(_ newSettings: UserSettings) {
        settings = newSettings
        save()
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(settings) {
            defaults.set(encoded, forKey: settingsKey)
        }
    }
}
