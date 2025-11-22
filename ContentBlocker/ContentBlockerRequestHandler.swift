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
        let defaults = UserDefaults(suiteName: "group.com.puranjanics.Focuser")
        var blockedDomains: [String] = []

        NSLog("ContentBlocker: Starting request")

        // Load blocked sites from shared UserDefaults
        if let data = defaults?.data(forKey: "blocked_sites"),
           let sites = try? JSONDecoder().decode([BlockedSiteData].self, from: data) {
            blockedDomains = sites.map { $0.domain }
            NSLog("ContentBlocker: Loaded \(blockedDomains.count) sites from App Groups")
        } else {
            NSLog("ContentBlocker: No sites found in App Groups, using defaults")
        }

        // If no sites in shared data, use default blocklist
        if blockedDomains.isEmpty {
            blockedDomains = getDefaultBlocklist()
            NSLog("ContentBlocker: Using default blocklist with \(blockedDomains.count) sites")
        }

        // Generate blocking rules
        let rules = generateBlockingRules(from: blockedDomains)
        NSLog("ContentBlocker: Generated \(rules.count) blocking rules")

        // Convert rules to JSON data and attach directly
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: rules, options: .prettyPrinted)

            // Write to a temporary file in the caches directory
            let fileManager = FileManager.default
            let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let fileURL = cacheDir.appendingPathComponent("blockerList.json")

            try jsonData.write(to: fileURL, options: .atomic)
            NSLog("ContentBlocker: Wrote rules to \(fileURL.path)")

            // Create attachment from the file
            let attachment = NSItemProvider(contentsOf: fileURL)!
            let item = NSExtensionItem()
            item.attachments = [attachment]

            context.completeRequest(returningItems: [item], completionHandler: nil)
        } catch {
            NSLog("ContentBlocker: Error generating rules: \(error.localizedDescription)")

            // Fallback to bundled blockerList.json
            if let bundledURL = Bundle.main.url(forResource: "blockerList", withExtension: "json") {
                let attachment = NSItemProvider(contentsOf: bundledURL)!
                let item = NSExtensionItem()
                item.attachments = [attachment]
                context.completeRequest(returningItems: [item], completionHandler: nil)
            }
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
            // Top adult video sites
            "pornhub.com",
            "xvideos.com",
            "xnxx.com",
            "xhamster.com",
            "redtube.com",
            "youporn.com",
            "tube8.com",
            "spankbang.com",
            "txxx.com",
            "beeg.com",
            "xnxx2.com",
            "xnxx3.com",
            "pornhd.com",
            "hdzog.com",
            "tnaflix.com",
            "empflix.com",
            "drtuber.com",
            "keezmovies.com",
            "extremetube.com",
            "sunporno.com",
            "alphaporno.com",
            "pornerbros.com",
            "vid123.com",
            "befuck.com",
            "anyporn.com",
            "4porn.com",
            "porn.com",
            "porngo.com",
            "porn300.com",
            "porntube.com",
            "pornone.com",
            "pornhat.com",
            "porndoe.com",
            "pornid.xxx",
            "porntrex.com",
            "pornktube.com",
            "youjizz.com",
            "xtube.com",
            "nuvid.com",
            "upornia.com",
            "fapdu.com",
            "yespornplease.com",
            "eporner.com",
            "hqporner.com",
            "motherless.com",
            "heavy-r.com",
            "hotmovs.com",
            "sex.com",
            "xxxvideo.sex",
            "xozilla.com",
            "vporn.com",
            "ok.xxx",
            "porndig.com",
            "sleazyneasy.com",
            "pornfaze.com",
            "watchmygf.me",
            "yuvutu.com",
            "fapster.xxx",

            // Live cam sites
            "chaturbate.com",
            "stripchat.com",
            "cam4.com",
            "bongacams.com",
            "livejasmin.com",
            "myfreecams.com",
            "flirt4free.com",
            "imlive.com",
            "camsoda.com",
            "streamate.com",
            "cam2cam.com",
            "xlovecam.com",
            "sexcamly.com",
            "chaturbate.org",
            "camster.com",
            "sakura.live",
            "jerkmate.com",
            "xcams.com",

            // Image/GIF sites
            "imagefap.com",
            "xbooru.com",
            "gelbooru.com",
            "rule34.xxx",
            "e621.net",
            "danbooru.donmai.us",
            "pornpics.com",
            "pichunter.com",
            "imagetwist.com",
            "imgbox.com",

            // Forums & communities
            "sankakucomplex.com",

            // Premium/Paysite
            "brazzers.com",
            "realitykings.com",
            "bangbros.com",
            "naughtyamerica.com",
            "twistys.com",
            "digitalplayground.com",
            "babes.com",
            "mofos.com",
            "fakehub.com",
            "familystrokes.com",
            "teamskeet.com",
            "evilangel.com",
            "wicked.com",
            "adulttime.com",
            "onlyfans.com",
            "fansly.com",
            "manyvids.com",
            "clips4sale.com",
            "iwantclips.com",

            // Hentai/Anime
            "hanime.tv",
            "nhentai.net",
            "hentaihaven.org",
            "tsumino.com",
            "fakku.net",
            "hentai2read.com",
            "hentaigasm.com",
            "simply-hentai.com",
            "hentaistream.com",
            "hentaifreak.org",
            "doujins.com",

            // Torrents/Downloads
            "empornium.me",
            "pornolab.net",
            "pornbay.org",
            "theporndude.com",

            // Dating/Hookup
            "adultfriendfinder.com",
            "ashleymadison.com",
            "fling.com",
            "passion.com",
            "benaughty.com",
            "together2night.com",

            // Other popular adult sites
            "spankwire.com",
            "ixxx.com",
            "tubegalore.com",
            "fuq.com",
            "pornmd.com",
            "gotporn.com",
            "cliphunter.com",
            "fux.com",
            "ah-me.com",
            "pinkworld.com",
            "perfectgirls.net",
            "analdin.com",
            "pornflip.com",
            "sexu.com",
            "shameless.com",
            "erome.com",
            "scrolller.com",
            "bunkr.is",
            "coomer.party",
            "kemono.party"
        ]
    }

}

// Mirror of the BlockedSite struct from main app
struct BlockedSiteData: Codable {
    let id: UUID
    let domain: String
    let isDefault: Bool
    let dateAdded: Date
}
