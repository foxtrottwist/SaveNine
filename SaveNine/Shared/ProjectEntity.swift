//
//  ProjectEntity.swift
//  SaveNine
//
//  Created by Lawrence Horne on 8/7/23.
//

import AppIntents
import OSLog
import SwiftData

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
        Logger.data.info("\(Self.self) – Loading projects using identifiers: \(identifiers).")
        let modelContext = ModelContext(Persistence.container)
        
        let projects = identifiers.compactMap { id in
            try! modelContext.fetch(
                FetchDescriptor<Project>(predicate: #Predicate { id == $0.id })
            )
        }.first!
        
        Logger.data.info("Found: \(projects.first.debugDescription)")
        return projects.map { ProjectEntity(from: $0)}
    }
    
    func suggestedEntities() async throws -> [ProjectEntity] {
        Logger.data.info("\(Self.self) – Loading projects to suggest.")
        let modelContext = ModelContext(Persistence.container)
        let projects = try! modelContext.fetch(FetchDescriptor<Project>())
        Logger.data.info("Found: \(projects.count)")
        return projects.map { ProjectEntity(from: $0)}
    }
}
