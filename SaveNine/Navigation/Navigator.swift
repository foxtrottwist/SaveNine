//
//  Navigator.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/29/23.
//

import Foundation
import Observation

@Observable
final class Navigator {
    // FIXME: investigate why path does not update correctly.
    var path: [Project] = []
    var link: NavigatorLink? = .open
    
    init() {}
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
