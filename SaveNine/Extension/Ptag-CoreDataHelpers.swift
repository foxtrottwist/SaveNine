//
//  Ptag-CoreDataHelpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 10/1/22.
//

import CoreData
import Foundation

extension Ptag {
    var ptagName: String {
        name ?? ""
    }
    
    var ptagProjects: [Project] {
        projects?.allObjects as? [Project] ?? []
    }
    
    static var fetchAllTags: NSFetchRequest<Ptag> {
        let request = Ptag.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Ptag.name, ascending: true)]
        
        return request
    }
}
