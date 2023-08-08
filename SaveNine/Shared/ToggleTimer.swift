//
//  ToggleTimer.swift
//  SaveNine
//
//  Created by Lawrence Horne on 8/5/23.
//

import AppIntents
import SwiftData
import WidgetKit

struct ToggleTimer: LiveActivityIntent {
    static var title: LocalizedStringResource = "Toggle Timer"
    static var description = IntentDescription("Starts a live activity timer for a given project if is not running and stops it if is running.")
    
    @Parameter(title: "Project")
    var project: ProjectEntity
    
    init(project: ProjectEntity) {
        self.project = project
    }
    
    init() {}
    
    func perform() async throws -> some IntentResult {
        let modelContext = ModelContext(Persistence.container)
        let id = project.id
        let fetchDescriptor = FetchDescriptor<Project>(predicate: #Predicate { $0.id == id })
        
        guard let project = try! modelContext.fetch(fetchDescriptor).first else { return .result() }
        
        if project.tracking ?? false {
            let currentSession = project.projectSessions.first
            let endDate = Date()
            currentSession?.endDate = endDate
            currentSession?.duration = endDate.timeIntervalSince(currentSession!.startDate!)
            project.modificationDate = endDate
            project.tracking = false
            await TimerActivity.shared.endLiveActivity()
        } else {
            let startDate = Date()
            let session = Session(label: nil, startDate: startDate, project: project)
            project.tracking = true
            project.sessions?.append(session)
            TimerActivity.shared.requestLiveActivity(project: project, date: startDate)
        }
        
        try! modelContext.save()
        WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.RecentlyTracked.rawValue)
        return .result()
    }
}


