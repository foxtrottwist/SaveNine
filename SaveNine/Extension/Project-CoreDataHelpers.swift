//
//  Project-CoreDataHelpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import CoreData
import Foundation

extension Project {
    var projectName: String {
        name ?? ""
    }
    
    var projectImage: String {
        image ?? ""
    }
    
    var projectDetail: String {
        detail ?? ""
    }
    
    var projectCreationDate: Date {
        creationDate ?? Date()
    }
    
    var projectChecklists: [Checklist] {
        let checklists = checklists?.allObjects as? [Checklist] ?? []
        
        return checklists.sorted(using: KeyPathComparator(\.creationDate, order: .reverse))
    }
    
    var projectSessions: [Session] {
        let sessions = sessions?.allObjects as? [Session] ?? []
        
        return sessions.sorted(using: KeyPathComparator(\.startDate, order: .reverse))
    }
    
    var projectShareSessions: String {
        let sessions = projectSessions.map {
            "\($0.formattedStartDate)\n\( $0.formattedDuration)"
         }.reduce("") { "\($0)\n\n\($1)" }
        
        let sharedSessions = """
            \(projectName)
            \(sessions)
            
            Time Tracked: \(projectFormattedTotalDuration)
            """

        return sharedSessions
    }
    
    var projectTags: [Ptag] {
        tags?.allObjects as? [Ptag] ?? []
    }
    
    var projectTagsString: String {
        projectTags.map { $0.ptagName }.sorted {$0 < $1 }.joined(separator: " ")
    }
    
    var projectTotalDuration: Double {
        projectSessions.map { $0.duration }.reduce(0.0) { $0 + $1 }
    }
    
    var projectFormattedTotalDuration: String {
        Duration.seconds(projectTotalDuration).formatted(.time(pattern: .hourMinuteSecond(padHourToLength: 2)))
    }
    
    static var example: Project {
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


