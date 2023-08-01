//
//  Session.swift
//  SaveNine
//
//  Created by Lawrence Horne on 8/1/23.
//
//

import Foundation
import SwiftData

@Model
public class Session {
    var duration: Double? = 0
    var endDate: Date?
    var label: String?
    var startDate: Date?
    var project: Project?

    init(duration: Double? = nil, endDate: Date? = nil, label: String? = nil, startDate: Date? = nil, project: Project? = nil) {
        self.duration = duration
        self.endDate = endDate
        self.label = label
        self.startDate = startDate
        self.project = project
    }
}
