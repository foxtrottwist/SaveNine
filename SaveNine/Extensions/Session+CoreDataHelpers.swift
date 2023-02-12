//
//  Session+CoreDataHelpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 10/15/22.
//

import Foundation

extension Session {
    var formattedStartDate: String {
        guard let startDate else { return "" }
        
        return startDate.formatted(date: .abbreviated, time: .shortened)
    }
    
    var formattedEndDate: String {
        guard let endDate else { return "" }
        
        return endDate.formatted(date: .abbreviated, time: .shortened)
    }
    
    var formattedDuration: String {
        duration.formattedDuration
    }
    
    var sessionLabel: String {
        label ?? DefaultLabel.none.rawValue
    }
    
    static var Example: Session {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let session = Session(context: viewContext)
        session.startDate = Date()
        session.endDate = Date().advanced(by: 3600)
        
        if let startDate = session.startDate, let endDate = session.endDate {
            session.duration = endDate.timeIntervalSince(startDate)
        }
        
        return session
    }
}
