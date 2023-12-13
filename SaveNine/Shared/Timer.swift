//
//  Timer.swift
//  SaveNine
//
//  Created by Lawrence Horne on 8/11/23.
//

import Foundation
import SwiftData

final class Timer {
    static let shared = Timer()
    
    func cancel(session: Session, modelContext: ModelContext, widget: WidgetKind? = nil) {
        session.project?.tracking = false
        modelContext.delete(session)
        
        if let widget {
            WidgetKind.reload(widget)
        }
        
        Task {
            await TimerActivity.shared.endLiveActivity(date: .now)
        }
    }
    
    func start(for project: Project, date: Date, label: String? = nil, widget: WidgetKind? = nil) {
        let startDate = Date()
        let _ = Session(label: label, startDate: startDate, project: project)
        project.tracking = true
        
        TimerActivity.shared.requestLiveActivity(project: project, date: startDate)
        
        if let widget {
            WidgetKind.reload(widget)
        }
    }
    
    func stop(session: Session, widget: WidgetKind? = nil) {
        let endDate = Date()
        session.endDate = endDate
        session.duration = endDate.timeIntervalSince(session.startDate!)
        session.project?.modificationDate = endDate
        session.project?.tracking = false
        
        if let label = session.label {
            Marker.updateLastUsed(for: label)
        }
        
        if let widget {
            WidgetKind.reload(widget)
        }
        
        Task {
            await TimerActivity.shared.endLiveActivity(date: endDate)
        }
    }
}
