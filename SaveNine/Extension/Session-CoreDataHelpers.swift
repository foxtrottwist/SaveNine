//
//  Session-CoreDataHelpers.swift
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
        Duration.seconds(duration).formatted(.time(pattern: .hourMinuteSecond(padHourToLength: 2)))
    }
}
