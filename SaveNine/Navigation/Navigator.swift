//
//  ProjectNavigation.swift
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
    var filter: AppNavigationLink? = .open
    
    init() {}
}

struct AppNavigationLink: Identifiable, Hashable, Codable {
    var id: UUID
    var name: String
    var icon: String
    
    static var all = AppNavigationLink(id: UUID(), name: "All Projects", icon: "tray")
    static var open = AppNavigationLink(id: UUID(), name: "Open Projects", icon: "tray.full")
    static var closed = AppNavigationLink(id: UUID(), name: "Closed Projects", icon: "archivebox")
    static var sessions = AppNavigationLink(id: UUID(), name: "Sessions", icon:  "clock")
}
