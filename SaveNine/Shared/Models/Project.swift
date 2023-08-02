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
    var closed: Bool? = false
    var creationDate: Date?
    var detail: String?
    public var id: UUID?
    var image: String?
    var modificationDate: Date?
    var name: String?
    @Relationship(.cascade, inverse: \Session.project) var sessions: [Session]?
    @Relationship(inverse: \Tag.projects) var tags: [Tag]?

    init(
        creationDate: Date? = .now,
        detail: String? = nil,
        id: UUID? = UUID(),
        image: String? = nil,
        modificationDate: Date? = nil,
        name: String?,
        sessions: [Session]? = [],
        tags: [Tag]? = []
    ) {
        self.creationDate = creationDate
        self.detail = detail
        self.id = id
        self.image = image
        self.modificationDate = modificationDate
        self.name = name
        self.sessions = sessions
        self.tags = tags
    }
}

extension Project {
    var displayName: String {
        name ?? ""
    }
    
    var displayTags: String {
        projectTags.map { $0.displayName }.sorted {$0 < $1 }.joined(separator: " ")
    }
    
    var projectCreationDate: Date {
        creationDate ?? Date()
    }
    
    var projectDetail: String {
        detail ?? ""
    }
    
    var projectImage: String {
        image ?? ""
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
            "\($0.sessionLabel)\n\($0.formattedStartDate)\n\( $0.formattedDuration)"
         }.reduce("") { "\($0)\n\n\($1)" }
        
        let sharedSessions = """
            \(displayName)
            Time Tracked: \(timeTracked)
            \(sessions)
            """

        return sharedSessions
    }
    
    var timeTracked: String {
        projectSessions.map { $0.duration }.reduce(0.0) { $0 + $1! }.formattedDuration
    }
    
    /// A Boolean value that indicates whether the Project is being tracked.
    var tracking: Bool {
        // A Session either
        // 1. does not exist; -> false
        // 2. exists and has a startDate & endDate both with a value; -> false
        // 3. exists and has a startDate with a value, and endDate without a value.
        //    This means the Session was created but not completed;  -> true
        guard let session = projectSessions.first else { return false }
        return session.endDate == nil
    }
    
    static var preview: Project {
        .init(
            detail: "Everything but the leaf.",
            name: "OMG David!",
            sessions: [Session.preview],
            tags: [Tag.preview]
        )
    }
}
