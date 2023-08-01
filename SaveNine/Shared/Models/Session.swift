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
    var id: UUID?
    var label: String?
    var startDate: Date?
    var project: Project?

    init(id: UUID? = UUID(), label: String? = nil, startDate: Date? = nil, project: Project? = nil) {
        self.label = label
        self.startDate = startDate
        self.project = project
    }
}

extension Session {
    var formattedStartDate: String {
        guard let startDate else { return "" }
        return startDate.formatted(date: .abbreviated, time: .shortened)
    }
    
    var formattedEndDate: String {
        guard let endDate else { return "" }
        return endDate.formatted(date: .abbreviated, time: .shortened)
    }
    
    var formattedDuration: String {
        duration!.formattedDuration
    }
    
    var sessionLabel: String {
        label ?? DefaultLabel.none.rawValue
    }
    
    static var preview: Session {
        let session = Session(label: "Quilting", startDate: .now, project: Project.preview)
        session.endDate = session.startDate!.advanced(by: 3600)
        session.duration = session.endDate!.timeIntervalSince(session.startDate!)
        return session
    }
}
