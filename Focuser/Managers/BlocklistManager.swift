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
    private let defaults = UserDefaults(suiteName: "group.com.puranjanics.Focuser") ?? .standard
    private let screenTimeManager = ScreenTimeManager.shared

    init() {
        loadBlockedSites()
        if blockedSites.isEmpty {
            loadDefaultBlocklist()
        } else {
            // Sync existing blocklist with Screen Time on init
            Task { @MainActor in
                if screenTimeManager.isAuthorized {
                    updateScreenTimeBlocks()
                }
            }
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

        // Also block in Screen Time (all browsers)
        Task { @MainActor in
            if screenTimeManager.isAuthorized {
                updateScreenTimeBlocks()
            }
        }
    }

    func removeSite(_ site: BlockedSite) {
        blockedSites.removeAll { $0.id == site.id }
        saveBlockedSites()
        reloadContentBlocker()

        // Also update Screen Time
        Task { @MainActor in
            if screenTimeManager.isAuthorized {
                updateScreenTimeBlocks()
            }
        }
    }

    @MainActor
    func updateScreenTimeBlocks() {
        let domains = blockedSites.map { $0.domain }
        screenTimeManager.blockWebsites(domains)
        print("BlocklistManager: Updated Screen Time with \(domains.count) domains")
    }

    private func loadDefaultBlocklist() {
        let defaultDomains = [
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
            "redtube.com",
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
            "sex.com",
            "pichunter.com",
            "imagetwist.com",
            "imgbox.com",

            // Forums & communities
            "reddit.com/r/nsfw",
            "reddit.com/r/gonewild",
            "4chan.org/b",
            "4chan.org/gif",
            "8chan.moe",
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
            "ashley madison.com",
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
            "fapster.xxx",
            "pornflip.com",
            "sexu.com",
            "shameless.com",
            "erome.com",
            "scrolller.com",
            "bunkr.is",
            "coomer.party",
            "kemono.party"
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
            defaults.synchronize()
            print("BlocklistManager: Saved \(blockedSites.count) sites to App Groups")

            // Verify save
            if let _ = defaults.data(forKey: blockedSitesKey) {
                print("BlocklistManager: Verification - data exists in App Groups ✓")
            } else {
                print("BlocklistManager: WARNING - data NOT found in App Groups after save!")
            }
        }
    }

    func reloadContentBlocker(completion: ((Bool, String?) -> Void)? = nil) {
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: "com.puranjanics.Focuser.ContentBlocker") { error in
            if let error = error {
                print("Error reloading content blocker: \(error.localizedDescription)")
                completion?(false, error.localizedDescription)
            } else {
                print("Content blocker reloaded successfully")
                completion?(true, nil)
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
