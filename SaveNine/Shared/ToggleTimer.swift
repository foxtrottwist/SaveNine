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
    static var description = IntentDescription ("Starts a live activity timer for a given project if is not running and stops it if is running.")
    
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
        
        if project.tracking {
            let currentSession = project.projectSessions.first
            let endDate = Date()
            currentSession?.endDate = endDate
            currentSession?.duration = endDate.timeIntervalSince(currentSession!.startDate!)
            project.modificationDate = endDate
            await TimerActivity.shared.endLiveActivity()
        } else {
            let startDate = Date()
            let session = Session(label: nil, startDate: startDate, project: project)
            project.sessions?.append(session)
            TimerActivity.shared.requestLiveActivity(project: project, date: startDate)
        }
        
        try! modelContext.save()
        return .result()
    }
}

struct ProjectEntity: AppEntity, Identifiable {
    var id: UUID
    var name: String
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    init(from project: Project) {
        self.id = project.id!
        self.name = project.name!
    }
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
    
    static var defaultQuery = ProjectQuery()
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Project"
}

struct ProjectQuery: EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [ProjectEntity] {
        return [ProjectEntity(from: Project.recentlyTracked!)]
    }
}

