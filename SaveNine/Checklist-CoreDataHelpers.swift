//
//  Checklist-CoreDataHelpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/25/22.
//

import Foundation

extension Checklist {
    var checklistName: String {
        name ?? "New List"
    }

    var checklistCreationDate: Date {
        creationDate ?? Date()
    }
    
    var checklistItems: [Item] {
       items?.allObjects as? [Item] ?? []
    }

    static var example: Checklist {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let list = Checklist(context: viewContext)
        list.name = "Example Title"
        list.creationDate = Date()
        
        return list
    }

}
