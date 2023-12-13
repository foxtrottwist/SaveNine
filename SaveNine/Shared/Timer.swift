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
    
    func cancel(session: Session, modelContext: ModelContext) {
        session.project?.tracking = false
        modelContext.delete(session)
        WidgetKind.reload(.recentlyTracked)
        
        Task {
            await TimerActivity.shared.endLiveActivity(date: .now)
        }
    }
    
    func start(for project: Project, date: Date, label: String? = nil) {
        let startDate = Date()
        let _ = Session(label: label, startDate: startDate, project: project)
        project.tracking = true
        
        TimerActivity.shared.requestLiveActivity(project: project, date: startDate)
        WidgetKind.reload(.recentlyTracked)
    }
    
    func stop(for project: Project, label: String? = nil) async {
        let currentSession = project.projectSessions.first
        let endDate = Date()
        
        currentSession?.endDate = endDate
        currentSession?.duration = endDate.timeIntervalSince(currentSession!.startDate!)
        currentSession?.label = label
        project.modificationDate = endDate
        project.tracking = false
        
        if let label { Marker.updateLastUsed(for: label) }
        await TimerActivity.shared.endLiveActivity(date: endDate)
    }
    
    func stop(session: Session) {
        let endDate = Date()
        session.endDate = endDate
        session.duration = endDate.timeIntervalSince(session.startDate!)
        session.project?.modificationDate = endDate
        session.project?.tracking = false
        
        WidgetKind.reload(.recentlyTracked)
        
        Task {
            await TimerActivity.shared.endLiveActivity(date: endDate)
        }
    }
}
