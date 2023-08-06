//
//  StartTimer.swift
//  SaveNine
//
//  Created by Lawrence Horne on 8/5/23.
//

import AppIntents
import Foundation
import SwiftData
import WidgetKit

struct StartTimer: AppIntent {
    static var title: LocalizedStringResource = "Start Timer"
    static var description = IntentDescription ("Start tracking a project.")
    
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
        } else {
            let session = Session(label: nil, startDate: .now, project: project)
            project.sessions?.append(session)
        }
        
        try! modelContext.save()
        
        WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.RecentlyTracked.rawValue)
        
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

