//
//  Persistence.swift
//  SaveNine
//
//  Created by Lawrence Horne on 8/5/23.
//

import SwiftData

public final class Persistence {}

public extension Persistence {
    @MainActor static var previewContainer: ModelContainer {
        do {
            let schema = Schema(models)
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: schema, configurations: configuration)
            
            for i in 1...9 {
                let label = Marker(name: "Label \(i)")
                let tag = Tag(name: "Tag \(i)")
                
                let session = Session(label: label.name, startDate: .now, project: nil)
                session.endDate = session.startDate?.addingTimeInterval(3600)
                session.duration = session.endDate?.timeIntervalSince(session.startDate!)
                
                let project = Project(name: "Project \(i)", sessions: [session], tags: [tag])
                container.mainContext.insert(project)
            }
            return container
        } catch {
            fatalError("Failed to create preview container: \(error.localizedDescription)")
        }
    }
}

public extension Persistence {
    static let container = try! ModelContainer(for: schema)
    static let models: [any PersistentModel.Type] = [Project.self, Session.self, Tag.self, Marker.self]
    static let schema = Schema(models)
}
