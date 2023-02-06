//
//  ProjectWidget.swift
//  SaveNine
//
//  Created by Lawrence Horne on 1/3/23.
//

import Foundation
import WidgetKit

struct ProjectWidget: Codable {
    let id: UUID
    let name: String
    let modifiedDate: Date
    let sessionCount: Int
    let timeTracked: String
    
    func writeMostRecentlyTrackedWidget() {
        FileManager.writeWidget(data: self, to: S9WidgetKind.LastTracked.fileName)
        WidgetCenter.shared.reloadTimelines(ofKind: S9WidgetKind.LastTracked.rawValue)
    }
    
    static var example: ProjectWidget {
        .init(id: UUID(), name: "Lucy Loo", modifiedDate: Date(), sessionCount: 3, timeTracked: 3734.formattedDuration)
    }
    
    static var mostRecentlyTrackedProject: ProjectWidget? {
        FileManager.readWidgetData(self, from: S9WidgetKind.LastTracked.fileName)
    }
}
