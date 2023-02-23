//
//  ProjectDocument.swift
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
            contents = try! JSONDecoder().decode(ProjectDocument.self, from: data)
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
//    let checkLists: [CheckListDocument]?
//    let sessions: [SessionDocument]?
    
    static var example: ProjectDocument {
        .init(id: UUID(), name: "It's Knot Spelled With a 'K'", closed: Bool(), creationDate: Date(), detail: "I didn't think was.")
    }
}

//struct SessionDocument: Codable {
//    let duration: Float
//    let endDate: Date
//    let label: String
//    let startDate: Date
//}
//
//struct CheckListDocument: Codable {
//    let name: String
//    let creationDate: Date
//    let items: [ItemDocument]?
//}
//
//struct ItemDocument: Codable {
//    let name: String
//    let completed: Bool
//    let creationDate: Date
//    let detail: String
//    let priority: Int
//}
