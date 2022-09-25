//
//  Item-CoreDataHelpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/25/22.
//

import Foundation

extension Item {
    var itemName: String {
        name ?? "New Item"
    }
    
    var itemDetail: String {
        detail ?? ""
    }
    
    var itemCreationDate: Date {
        creationDate ?? Date()
        
    }
    
    static var example: Item {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
           
        let item = Item(context: viewContext)
        item.name = "Example Title"
        item.detail = "This is an example item"
        item.priority = 3
        item.creationDate = Date()
           
        return item
    }
}
