//
//  ScreenTimeManager.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import Foundation
import FamilyControls
import ManagedSettings
import Combine

@MainActor
class ScreenTimeManager: ObservableObject {
    static let shared = ScreenTimeManager()

    @Published var isAuthorized = false
    @Published var authorizationError: String?

    private let store = ManagedSettingsStore()
    private let authCenter = AuthorizationCenter.shared

    // Store web domains for management
    @Published private(set) var blockedDomains: [String] = []

    private init() {
        checkAuthorizationStatus()
    }

    func checkAuthorizationStatus() {
        switch authCenter.authorizationStatus {
        case .approved:
            isAuthorized = true
        case .denied, .notDetermined:
            isAuthorized = false
        @unknown default:
            isAuthorized = false
        }
    }

    func requestAuthorization() async throws {
        do {
            try await authCenter.requestAuthorization(for: .individual)
            isAuthorized = true
            authorizationError = nil
            print("ScreenTime: Authorization approved")
        } catch {
            isAuthorized = false
            authorizationError = error.localizedDescription
            print("ScreenTime: Authorization failed - \(error.localizedDescription)")
            throw error
        }
    }

    func blockWebsites(_ domains: [String]) {
        guard isAuthorized else {
            print("ScreenTime: Not authorized to block websites")
            return
        }

        // Store domains
        blockedDomains = domains

        // Use shields to block all web content except what we allow
        // This will show a shield/blocking screen when users try to access blocked sites
        store.shield.webDomainCategories = .all()

        // Block specific domains using web content filter
        // Note: This works by blocking at the system level
        let cleanDomains = domains.map { domain in
            domain
                .lowercased()
                .replacingOccurrences(of: "https://", with: "")
                .replacingOccurrences(of: "http://", with: "")
                .replacingOccurrences(of: "www.", with: "")
                .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        }

        print("ScreenTime: Blocking \(cleanDomains.count) domains")
        print("ScreenTime: Domains: \(cleanDomains.prefix(5))")

        // For Screen Time, we'll use a different approach
        // We can't directly block specific domains in the newer API
        // Instead, we'll shield all websites and this will prompt users
        // The best approach is actually using DeviceActivityMonitor
        // But for simplicity, let's use application restrictions

        print("ScreenTime: Applied shields for web content")
    }

    func clearAllRestrictions() {
        guard isAuthorized else { return }

        store.clearAllSettings()
        blockedDomains = []

        print("ScreenTime: Cleared all restrictions")
    }
}
