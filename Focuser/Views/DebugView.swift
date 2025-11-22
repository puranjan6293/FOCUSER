//
//  DebugView.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import SwiftUI

struct DebugView: View {
    @State private var debugInfo = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("App Groups Debug Info")
                        .font(.headline)

                    Button("Check App Groups") {
                        checkAppGroups()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    Text(debugInfo)
                        .font(.system(.caption, design: .monospaced))
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Debug")
        }
    }

    func checkAppGroups() {
        var info = ""

        // Check if App Groups are accessible
        let appGroupID = "group.com.puranjanics.Focuser"
        if let defaults = UserDefaults(suiteName: appGroupID) {
            info += "✓ App Groups accessible\n"
            info += "App Group ID: \(appGroupID)\n\n"

            // Check for blocked sites data
            if let data = defaults.data(forKey: "blocked_sites") {
                info += "✓ Blocked sites data found\n"
                info += "Data size: \(data.count) bytes\n"

                if let sites = try? JSONDecoder().decode([BlockedSite].self, from: data) {
                    info += "✓ Successfully decoded \(sites.count) sites\n\n"
                    info += "Sites:\n"
                    for site in sites.prefix(10) {
                        info += "- \(site.domain)\n"
                    }
                    if sites.count > 10 {
                        info += "... and \(sites.count - 10) more\n"
                    }
                } else {
                    info += "✗ Failed to decode sites data\n"
                }
            } else {
                info += "✗ No blocked sites data found\n"
                info += "This means App Groups might not be configured!\n"
            }
        } else {
            info += "✗ App Groups NOT accessible\n"
            info += "App Group ID: \(appGroupID)\n"
            info += "\nYou need to configure App Groups in Xcode:\n"
            info += "1. Select Focuser target\n"
            info += "2. Go to Signing & Capabilities\n"
            info += "3. Add App Groups capability\n"
            info += "4. Add: \(appGroupID)\n"
            info += "5. Repeat for ContentBlocker target\n"
        }

        debugInfo = info
    }
}
