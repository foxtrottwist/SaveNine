//
//  Tag+CoreDataHelpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 10/1/22.
//

import CoreData
import Foundation

extension Tag {
    var displayName: String {
        name ?? ""
    }
    
    var tagProjects: [Project] {
        projects?.allObjects as? [Project] ?? []
    }
    
    static var fetchAllTags: NSFetchRequest<Tag> {
        let request = Tag.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Tag.name, ascending: true)]
        
        return request
    }
    
    static var preview: Tag {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let tag = Tag(context: viewContext)
        tag.name = "fpp"
        
        return tag
    }
}
