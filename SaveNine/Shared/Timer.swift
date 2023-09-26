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
    
    func cancel(for project: Project) async -> Session? {
        let currentSession = project.projectSessions.first
        guard let currentSession else { return nil }
        
        project.tracking = false
        
        await TimerActivity.shared.endLiveActivity(date: .now)
        return currentSession
    }
    
    func start(for project: Project, date: Date, label: String? = nil) {
        let session = Session(label: label, startDate: date, project: project)
        
        project.tracking = true
        project.sessions?.append(session)
        
        TimerActivity.shared.requestLiveActivity(project: project, date: date)
    }
    
    func stop(for project: Project, label: String? = nil) async {
        let currentSession = project.projectSessions.first
        let endDate = Date()
        
        currentSession?.endDate = endDate
        currentSession?.duration = endDate.timeIntervalSince(currentSession!.startDate!)
        currentSession?.label = label
        project.modificationDate = endDate
        project.tracking = false
        
        await TimerActivity.shared.endLiveActivity(date: endDate)
    }
}
