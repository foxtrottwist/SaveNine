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
        Logger.statistics.info("\(Self.self) – Loading projects using identifiers: \(identifiers).")
        let modelContext = ModelContext(Persistence.container)
        let projects = try! modelContext.fetch(FetchDescriptor<Project>())
        let entity = projects.filter { identifiers.contains($0.id!) }.map { ProjectEntity(from: $0)}
        Logger.statistics.info("Found: \(entity.first.debugDescription)")
        return entity
    }
    
    func suggestedEntities() async throws -> [ProjectEntity] {
        Logger.statistics.info("\(Self.self) – Loading projects to suggest.")
        let modelContext = ModelContext(Persistence.container)
        let projects = try! modelContext.fetch(FetchDescriptor<Project>())
        Logger.statistics.info("Found: \(projects.first?.tracking ?? false)")
        return projects.map { ProjectEntity(from: $0)}
    }
}
