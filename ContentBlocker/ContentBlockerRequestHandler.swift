//
//  ContentBlockerRequestHandler.swift
//  ContentBlocker
//
//  Created by Puranjan Mallik on 22/11/25.
//

import UIKit
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        // Try to load blocklist from App Groups (shared with main app)
        let defaults = UserDefaults(suiteName: "group.com.focuser.app")
        var blockedDomains: [String] = []

        // Load blocked sites from shared UserDefaults
        if let data = defaults?.data(forKey: "blocked_sites"),
           let sites = try? JSONDecoder().decode([BlockedSiteData].self, from: data) {
            blockedDomains = sites.map { $0.domain }
        }

        // If no sites in shared data, use default blocklist
        if blockedDomains.isEmpty {
            blockedDomains = getDefaultBlocklist()
        }

        // Generate blocking rules
        let rules = generateBlockingRules(from: blockedDomains)

        // Convert rules to JSON data
        if let jsonData = try? JSONSerialization.data(withJSONObject: rules, options: []),
           let tempURL = writeTempJSON(jsonData) {
            let attachment = NSItemProvider(contentsOf: tempURL)!
            let item = NSExtensionItem()
            item.attachments = [attachment]
            context.completeRequest(returningItems: [item], completionHandler: nil)
        } else {
            // Fallback to bundled blockerList.json
            let attachment = NSItemProvider(contentsOf: Bundle.main.url(forResource: "blockerList", withExtension: "json"))!
            let item = NSExtensionItem()
            item.attachments = [attachment]
            context.completeRequest(returningItems: [item], completionHandler: nil)
        }
    }

    private func generateBlockingRules(from domains: [String]) -> [[String: Any]] {
        var rules: [[String: Any]] = []

        for domain in domains {
            // Escape dots in domain for regex
            let escapedDomain = domain.replacingOccurrences(of: ".", with: "\\.")

            let rule: [String: Any] = [
                "trigger": [
                    "url-filter": ".*\(escapedDomain).*",
                    "resource-type": ["document", "image", "style-sheet", "script", "media", "font", "raw", "svg-document", "popup"]
                ],
                "action": [
                    "type": "block"
                ]
            ]
            rules.append(rule)
        }

        return rules
    }

    private func getDefaultBlocklist() -> [String] {
        return [
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
            "stripchat.com",
            "pornhd.com",
            "xmoviesforyou.com",
            "drtuber.com",
            "keezmovies.com",
            "extremetube.com"
        ]
    }

    private func writeTempJSON(_ data: Data) -> URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("blockerList.json")

        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Error writing temp JSON: \(error)")
            return nil
        }
    }
}

// Mirror of the BlockedSite struct from main app
struct BlockedSiteData: Codable {
    let id: UUID
    let domain: String
    let isDefault: Bool
    let dateAdded: Date
}
