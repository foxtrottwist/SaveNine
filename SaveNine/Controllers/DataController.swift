//
//  DataController.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import CoreData
import SwiftUI

/// An environment singleton responsible for managing our Core Data stack, including handling saving
/// and deleting, counting fetch requests, and dealing with sample data.
class DataController: ObservableObject {
    /// The CloudKit container used to store all our data.
    let container: NSPersistentCloudKitContainer
    
    /// Initializes a data controller, either in memory (for temporary use such as testing and previewing),
    /// or on permanent storage (for use in regular app runs).
    ///
    /// Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store this data in temporary memory or not.
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        
        // For testing and previewing purposes, we create a
        // temporary, in-memory database by writing to /dev/null
        // so our data is destroyed after the app finishes running.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
            
            self.container.viewContext.automaticallyMergesChangesFromParent = true
        }
    }
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating previews : \(error.localizedDescription)")
        }
        
        return dataController
    }()
    
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
    /// Creates example projects and items to make manual testing easier.
    /// - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData() throws {
        let viewContext = container.viewContext
        let projects = ["OMG David!", "Chip, the Goldfinch", "Deep Dive", "Ursula Minor", "Big G, the Giraffe"]
        let tags = ["fpp", "quilting", "animals"]
        
        for p in projects {
            let project = Project(context: viewContext)
            project.name = p
            project.id = UUID()
            project.creationDate = Date()
            project.closed = Bool.random()
        }
        
        for t in tags {
            let tag = Tag(context: viewContext)
            tag.name = t
            tag.id = UUID()
        }
        
        try viewContext.save()
    }
    
    /// Saves our Core Data context iff there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because our
    /// attributes are optional.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }
    
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest (fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        if let delete = try? container.viewContext.execute (batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObject] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave:changes, into:[container.viewContext])
        }
    }
    
    func deleteAll() {
        let fetchRequest3: NSFetchRequest<NSFetchRequestResult> = Session.fetchRequest()
        delete(fetchRequest3)
        
        let fetchRequest4: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(fetchRequest4)
        
        let fetchRequest5: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        delete(fetchRequest5)
        
        save()
    }
}
