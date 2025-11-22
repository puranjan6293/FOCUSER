//
//  FocuserApp.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import SwiftUI

@main
struct FocuserApp: App {
    @StateObject private var settingsManager = SettingsManager()

    var body: some Scene {
        WindowGroup {
            if settingsManager.settings.hasCompletedOnboarding {
                HomeView()
                    .environmentObject(settingsManager)
            } else {
                OnboardingView(isOnboardingComplete: .init(
                    get: { settingsManager.settings.hasCompletedOnboarding },
                    set: { _ in settingsManager.completeOnboarding() }
                ))
                .environmentObject(settingsManager)
            }
        }
    }
}
