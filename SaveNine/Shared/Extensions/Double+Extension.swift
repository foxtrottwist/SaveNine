//
//  Double+Extension.swift
//  SaveNine
//
//  Created by Lawrence Horne on 1/4/23.
//

import Foundation

extension Double {
    var formattedDuration: String {
        Duration.seconds(self).formatted(.time(pattern: .hourMinuteSecond(padHourToLength: 2)))
    }
    
    var timerFormattedDuration: String {
        let duration = -self
        return duration.formattedDuration
    }
}
