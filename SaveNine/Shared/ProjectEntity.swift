//
//  ProjectEntity.swift
//  SaveNine
//
//  Created by Lawrence Horne on 8/7/23.
//

import AppIntents

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
    
    func suggestedEntities() async throws -> [ProjectEntity] {
        Project.projects.map { ProjectEntity(from: $0!)}
    }
}
