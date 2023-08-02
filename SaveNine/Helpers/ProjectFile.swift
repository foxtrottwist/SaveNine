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
    let sessions: [SessionDocument]?
    
    static func document(from project: Project) -> ProjectFile {
        return ProjectFile(
            contents: .init(
                id: project.id!,
                name: project.displayName,
                closed: project.closed!,
                creationDate: project.projectCreationDate,
                detail: project.projectDetail,
                sessions: SessionDocument.document(from: project.projectSessions)
            )
        )
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
                duration: session.duration!,
                endDate: session.endDate!,
                label: session.sessionLabel,
                startDate: session.startDate!
            )
        }
    }
}
