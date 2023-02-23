//
//  ProjectFile.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/22/23.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct ProjectFile: FileDocument {
    static var readableContentTypes: [UTType] = [UTType.json]
   
    let contents: ProjectDocument
    
    init(contents: ProjectDocument) {
        self.contents = contents
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            do {
                contents = try JSONDecoder().decode(ProjectDocument.self, from: data)
            } catch {
                throw CocoaError(.fileReadCorruptFile)
            }
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        if let data = try? JSONEncoder().encode(contents) {
        return FileWrapper(regularFileWithContents: data)
        } else {
            throw CocoaError(.coderInvalidValue)
        }
    }
}

struct ProjectDocument: Codable {
    let id: UUID
    let name: String
    let closed: Bool
    let creationDate: Date
    let detail: String
    let checklists: [ChecklistDocument]?
    let sessions: [SessionDocument]?
    
    static func document(from project: Project) -> ProjectFile {
        return ProjectFile(
            contents: .init(
                id: project.id!,
                name: project.projectName,
                closed: project.closed,
                creationDate: project.projectCreationDate,
                detail: project.projectDetail,
                checklists: ChecklistDocument.document(from: project.projectChecklists),
                sessions: SessionDocument.document(from: project.projectSessions)
            )
        )
    }
}

struct ChecklistDocument: Codable {
    let name: String
    let creationDate: Date
    let items: [ItemDocument]?
    
    static func document(from checklists: [Checklist]) -> [ChecklistDocument]{
        return checklists.map { checklist in
            ChecklistDocument(
                name: checklist.checklistName,
                creationDate: checklist.checklistCreationDate,
                items: ItemDocument.document(from: checklist.checklistItems)
            )
        }
    }
}

struct ItemDocument: Codable {
    let name: String
    let completed: Bool
    let creationDate: Date
    let detail: String
    let priority: Int16
    
    static func document(from items: [Item]) -> [ItemDocument] {
        return items.map { item in
            ItemDocument(
                name: item.itemName,
                completed: item.completed,
                creationDate: item.itemCreationDate,
                detail: item.itemDetail,
                priority: item.priority
            )
        }
    }
}

struct SessionDocument: Codable {
    let duration: Double
    let endDate: Date
    let label: String
    let startDate: Date
    
    static func document(from sessions: [Session]) -> [SessionDocument] {
        return sessions.map { session in
            SessionDocument(
                duration: session.duration,
                endDate: session.endDate!,
                label: session.sessionLabel,
                startDate: session.startDate!
            )
        }
    }
}
