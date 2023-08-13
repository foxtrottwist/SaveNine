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
    static let shared = Navigator()
    var link: NavigatorLink? = .open
    var path: [Project] = []
    
    let subject = PassthroughSubject<String?, Never>()
    
    var selectedTab: String? {
        willSet {
            if selectedTab == newValue {
                subject.send(newValue)
            }
        }
    }
}

struct NavigatorLink: Identifiable, Hashable, Codable {
    var id: UUID
    var name: String
    var icon: String
    
    static var all = NavigatorLink(id: UUID(), name: "All Projects", icon: "tray")
    static var open = NavigatorLink(id: UUID(), name: "Open Projects", icon: "tray.full")
    static var closed = NavigatorLink(id: UUID(), name: "Closed Projects", icon: "archivebox")
    static var sessions = NavigatorLink(id: UUID(), name: "Sessions", icon:  "clock")
}
