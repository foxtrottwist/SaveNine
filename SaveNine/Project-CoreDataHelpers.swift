//
//  Project-CoreDataHelpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import Foundation

extension Project {
    var projectName: String {
        name ?? "New Project"
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
    
    var projectItemLists: [ItemList] {
       itemLists?.allObjects as? [ItemList] ?? []
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


