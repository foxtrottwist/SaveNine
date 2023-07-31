//
//  ProjectNavigation.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/29/23.
//

import Foundation
import Observation

@Observable
final class AppNavigation {
    // FIXME: investigate why path does not update correctly.
    var path: [Project] = []
    var filter: Filter? = Filter.open
    
    init() {}
}

struct Filter: Identifiable, Hashable, Codable {
    var id: UUID
    var name: String
    var icon: String
    
    static var all = Filter(id: UUID(), name: "All Projects", icon: "tray")
    static var open = Filter(id: UUID(), name: "Open Projects", icon: "tray.full")
    static var closed = Filter(id: UUID(), name: "Closed Projects", icon: "archivebox")
    static var sessions = Filter(id: UUID(), name: "Sessions", icon:  "clock")
}
