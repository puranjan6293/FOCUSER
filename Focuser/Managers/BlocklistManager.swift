//
//  BlocklistManager.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import Foundation
import SafariServices

class BlocklistManager: ObservableObject {
    @Published var blockedSites: [BlockedSite] = []

    private let blockedSitesKey = "blocked_sites"
    private let defaults = UserDefaults(suiteName: "group.com.focuser.app") ?? .standard

    init() {
        loadBlockedSites()
        if blockedSites.isEmpty {
            loadDefaultBlocklist()
        }
    }

    func addSite(_ domain: String) {
        let cleanDomain = domain
            .lowercased()
            .replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "http://", with: "")
            .replacingOccurrences(of: "www.", with: "")

        guard !blockedSites.contains(where: { $0.domain == cleanDomain }) else { return }

        let newSite = BlockedSite(domain: cleanDomain, isDefault: false)
        blockedSites.append(newSite)
        saveBlockedSites()
        reloadContentBlocker()
    }

    func removeSite(_ site: BlockedSite) {
        blockedSites.removeAll { $0.id == site.id }
        saveBlockedSites()
        reloadContentBlocker()
    }

    private func loadDefaultBlocklist() {
        let defaultDomains = [
            "pornhub.com",
            "xvideos.com",
            "xnxx.com",
            "redtube.com",
            "youporn.com",
            "tube8.com",
            "spankbang.com",
            "xhamster.com",
            "txxx.com",
            "beeg.com",
            "eporner.com",
            "motherless.com",
            "hqporner.com",
            "4porn.com",
            "porn.com",
            "tnaflix.com",
            "porntrex.com",
            "cam4.com",
            "chaturbate.com",
            "stripchat.com"
        ]

        blockedSites = defaultDomains.map { domain in
            BlockedSite(domain: domain, isDefault: true)
        }
        saveBlockedSites()
    }

    private func loadBlockedSites() {
        if let data = defaults.data(forKey: blockedSitesKey),
           let decoded = try? JSONDecoder().decode([BlockedSite].self, from: data) {
            self.blockedSites = decoded
        }
    }

    private func saveBlockedSites() {
        if let encoded = try? JSONEncoder().encode(blockedSites) {
            defaults.set(encoded, forKey: blockedSitesKey)
        }
    }

    func reloadContentBlocker() {
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: "com.focuser.app.ContentBlocker") { error in
            if let error = error {
                print("Error reloading content blocker: \(error.localizedDescription)")
            }
        }
    }

    func generateBlockerJSON() -> String {
        var rules: [[String: Any]] = []

        for site in blockedSites {
            let rule: [String: Any] = [
                "trigger": [
                    "url-filter": ".*\(site.domain).*",
                    "resource-type": ["document", "image", "style-sheet", "script", "media"]
                ],
                "action": [
                    "type": "block"
                ]
            ]
            rules.append(rule)
        }

        if let jsonData = try? JSONSerialization.data(withJSONObject: rules, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }

        return "[]"
    }
}
