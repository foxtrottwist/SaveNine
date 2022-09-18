//
//  TimeHelpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/18/22.
//

import Foundation

func format(duration: Double) -> String {
    let time = Int(duration.rounded(.up))
    let hours = time / 60 / 60
    let minutes = (time - (hours * 60 * 60)) / 60
    
    return "\(hours) \(hours == 1 ? "hr" : "hrs") and \(minutes) \(minutes == 1 ? "min" : "mins") "
}
