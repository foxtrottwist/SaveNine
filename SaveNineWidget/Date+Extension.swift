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
    
    var widgetFormattedDate: String {
        if Calendar.current.isDateInToday(self) {
            return self.hourMinute
        }
        
        if Calendar.current.isDate(self, equalTo: .now, toGranularity: .weekOfYear) {
            return self.day
        }
        
        return self.formatted(date: .numeric, time: .omitted)
    }
}
