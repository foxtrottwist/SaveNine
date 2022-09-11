//
//  ItemList-CoreDataHelpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import Foundation

extension ItemList {
    var itemListName: String {
        name ?? "New List"
    }

    var itemListDetail: String {
        detail ?? ""
    }

    var itemListCreationDate: Date {
        creationDate ?? Date()
    }
    
    var itemListItems: [Item] {
       items?.allObjects as? [Item] ?? []
    }

    static var example: ItemList {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let list = ItemList(context: viewContext)
        list.name = "Example Title"
        list.detail = "This is an example item"
        list.creationDate = Date()
        
        return list
    }

}

