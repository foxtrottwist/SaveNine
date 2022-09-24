//
//  Project-CoreDataHelpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

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
    
    var projectSessions: [Session] {
        let sessions = sessions?.allObjects as? [Session] ?? []
        
        return sessions.sorted { a, b in
            if let a = a.startDate, let b = b.startDate {
                return  a < b
            } else {
                return true
            }
        }
    }
    
    var projectTotalDuration: Double {
        projectSessions.compactMap { $0.duration }.reduce(0.0) { $0 + $1 }
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
}


