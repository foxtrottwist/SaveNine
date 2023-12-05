//
//  Project.swift
//  SaveNine
//
//  Created by Lawrence Horne on 8/1/23.
//
//

import Foundation
import SwiftData

@Model
public class Project {
    public var id: UUID?
    var closed: Bool?
    var creationDate: Date?
    var detail: String = ""
    var modificationDate: Date?
    var name: String = ""
    var tracking: Bool?
    @Attribute(.externalStorage) var image: Data?
    @Relationship(deleteRule: .cascade, inverse: \Session.project) var sessions: [Session]?
    @Relationship(inverse: \Tag.projects) var tags: [Tag]?

    init(
        creationDate: Date? = .now,
        detail: String = "",
        image: Data? = nil,
        modificationDate: Date? = nil,
        name: String,
        sessions: [Session]? = [],
        tags: [Tag]? = []
    ) {
        self.closed = false
        self.creationDate = creationDate
        self.detail = detail
        self.id = UUID()
        self.image = image
        self.modificationDate = modificationDate
        self.name = name
        self.sessions = sessions
        self.tags = tags
        self.tracking = false
    }
}

extension Project {
    var displayTags: String {
        projectTags.map { $0.displayName }.sorted {$0 < $1 }.joined(separator: " ")
    }
    
    var projectCreationDate: Date {
        creationDate ?? Date()
    }
    
    var projectModificationDate: Date {
        modificationDate ?? Date()
    }
    
    var projectSessions: [Session] {
        let sessions = sessions ?? []
        return sessions.sorted(using: KeyPathComparator(\.startDate, order: .reverse))
    }
    
    var projectTags: [Tag] {
        tags ?? []
    }
    
    var sessionsShareLinkItem: String {
        let sessions = projectSessions.sorted(using: KeyPathComparator(\.startDate)).map {
            "\($0.displayLabel)\n\($0.formattedStartDate)\n\( $0.formattedDuration)"
         }.reduce("") { "\($0)\n\n\($1)" }
        
        let sharedSessions = """
            \(name)
            Time Tracked: \(timeTracked)
            \(sessions)
            """

        return sharedSessions
    }
    
    var timeTracked: String {
        projectSessions.map { $0.duration }.reduce(0.0) { $0 + $1! }.formattedDuration
    }
    
    static var preview: Project {
        let project = Project(
            detail: "Everything but the leaf.",
            name: "OMG David!",
            sessions: [Session.preview],
            tags: [Tag.preview]
        )
        
        project.modificationDate = Session.preview.endDate
        return project
    }
}

extension Project {
    static var projects: [Project?] {
        let modelContext = ModelContext(Persistence.container)
        return try! modelContext.fetch(FetchDescriptor<Project>())
    }
    
    static var recentlyTracked: Project? {
        let modelContext = ModelContext(Persistence.container)
        
        let fetchDescriptor = FetchDescriptor<Project>(
            predicate: #Predicate { $0.modificationDate != nil }, sortBy: [SortDescriptor(\.modificationDate, order: .reverse)]
        )
        
        return try! modelContext.fetch(fetchDescriptor).first
    }
    
    static func predicate(searchText: String = "", closed: Bool? = nil, id: UUID? = nil, tracking: Bool? = nil) -> Predicate<Project> {
        #Predicate { project in
            (searchText.isEmpty || project.name.localizedStandardContains(searchText)) &&
            (closed == nil || project.closed == closed) &&
            (id == nil || project.id == id) &&
            (tracking == nil || project.tracking == tracking)
        }
    }
}
