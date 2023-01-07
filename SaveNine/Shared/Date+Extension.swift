//
//  Date+Extension.swift
//  SaveNineWidgetExtension
//
//  Created by Lawrence Horne on 1/4/23.
//

import Foundation

extension Date {
    var day: String {
        self.formatted(.dateTime.weekday(.wide))
    }
    
    var hourMinute: String {
        self.formatted(date: .omitted, time: .shortened)
    }
    
    var numericDate: String {
        self.formatted(date: .numeric, time: .omitted)
    }
    
    /// Provides a description of the date using relative terms.
    /// - Parameter hourMinute: Determines whether the time of day or the word "Today" will be returned
    /// if the date and the current date are the same day.
    /// - Returns: A description of the date relative to the current date ("Today", "Yesterday", "Monday" etc.)
    /// If the date is further than week from the current date a numeric date will be returned – 1/08/2008.
    func relativeDescription(hourMinute: Bool = true) -> String {
        if Calendar.current.isDateInToday(self) {
            return hourMinute ? self.hourMinute : "Today"
        }
        
        if Calendar.current.isDateInYesterday(self) {
            return "Yesterday"
        }
        
        if Calendar.current.isDate(self, equalTo: .now, toGranularity: .weekOfYear) {
            return self.day
        }
        
        return self.numericDate
    }
}


