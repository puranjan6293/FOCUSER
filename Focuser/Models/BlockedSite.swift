//
//  BlockedSite.swift
//  Focuser
//
//  Created by Puranjan Mallik on 22/11/25.
//

import Foundation

struct BlockedSite: Identifiable, Codable, Hashable {
    let id: UUID
    var domain: String
    var isDefault: Bool
    var dateAdded: Date

    init(id: UUID = UUID(), domain: String, isDefault: Bool = false, dateAdded: Date = Date()) {
        self.id = id
        self.domain = domain
        self.isDefault = isDefault
        self.dateAdded = dateAdded
    }
}
