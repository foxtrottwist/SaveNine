//
//  Project+CoreDataHelpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import CoreData
import Foundation

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
    
    /// The Project's [Session] sorted in reverse chronological order.
    var projectSessions: [Session] {
        let sessions = sessions?.allObjects as? [Session] ?? []
        return sessions.sorted(using: KeyPathComparator(\.startDate, order: .reverse))
    }
    
    var projectTags: [Tag] {
        tags?.allObjects as? [Tag] ?? []
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
        projectSessions.map { $0.duration }.reduce(0.0) { $0 + $1 }.formattedDuration
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
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let project = Project(context: viewContext)
        project.name = "OMG David"
        project.detail = "Everything but the leaf!"
        project.closed = false
        project.creationDate = Date()
        
        return project
    }
    
    static func fetchProjects(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> NSFetchRequest<Project> {
        let request = Project.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        return request
    }
}


