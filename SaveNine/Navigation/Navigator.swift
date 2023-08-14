//
//  Navigator.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/29/23.
//

import Combine
import Foundation
import Observation

@Observable
final class Navigator {
    var path: [Project] = []
    var selectedLink: NavigatorLink? = .open
    
    let subject = PassthroughSubject<String?, Never>()
    
    var selectedTab: String? {
        willSet {
            if selectedTab == newValue {
                subject.send(newValue)
            }
        }
    }
    
    static let shared = Navigator()
}

struct NavigatorLink: Identifiable, Hashable, Codable {
    var id: UUID
    var name: String
    var icon: String
    
    init(id: UUID, name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
    }
    
    init(from tag: Tag) {
        id = tag.id!
        name = tag.displayName
        icon = "tag"
    }
    
    static var all = NavigatorLink(id: UUID(), name: "All Projects", icon: "tray")
    static var open = NavigatorLink(id: UUID(), name: "Open Projects", icon: "tray.full")
    static var closed = NavigatorLink(id: UUID(), name: "Closed Projects", icon: "archivebox")
    static var sessions = NavigatorLink(id: UUID(), name: "Sessions", icon:  "clock")
}
