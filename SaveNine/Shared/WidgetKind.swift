//
//  WidgetKind.swift
//  SaveNine
//
//  Created by Lawrence Horne on 1/4/23.
//

import Foundation
import OSLog
import WidgetKit

enum WidgetKind: String {
    case all
    case none
    case recentlyTracked = "RecentlyTracked"
    
    static func reload(_ kind: Self) {
        Logger.statistics.info("Reloading widget kind – \(kind.rawValue)")
        switch kind {
        case .all:
            WidgetCenter.shared.reloadAllTimelines()
        case .recentlyTracked:
            WidgetCenter.shared.reloadTimelines(ofKind: self.recentlyTracked.rawValue)
        case .none: break
        }
    }
}
