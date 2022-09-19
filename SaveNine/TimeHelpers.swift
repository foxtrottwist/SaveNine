//
//  TimeHelpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/18/22.
//

import Foundation

enum TimeValue {
    case hours, minutes, seconds
}

func elapsedTime(since start: Date, in format: TimeValue ) -> String {
    let elapsedTime = Int(-start.timeIntervalSinceNow.rounded())
    let hours = elapsedTime / 60 / 60
    let minutes = (elapsedTime - (hours * 60 * 60)) / 60
    
    switch format {
    case .hours:
        return hours <= 9 ? "0\(hours)" : "\(hours)"
    case .minutes:
        return minutes <= 9 ? "0\(minutes)" : "\(minutes)"
    case .seconds:
        return seconds(elapsedTime)
    }
}

func seconds(_ seconds: Int) -> String {
    if seconds > 60 {
        let remainder = seconds % 60
        return remainder <= 9 ? "0\(remainder)" : "\(remainder)"
    } else if seconds > 9 {
        return "\(seconds)"
    }
    
    return "0\(seconds)"
}

func format(duration: Double, in format: TimeValue) -> String {
    let time = Int(duration.rounded(.up))
    let hours = time / 60 / 60
    let minutes = (time - (hours * 60 * 60)) / 60
    
    
    switch format {
    case .hours:
        return hours > 0 ? "\(hours) \(hours == 1 ? "hr" : "hrs")" : ""
    case .minutes:
        return minutes > 0 ? "\(minutes) \(minutes == 1 ? "min" : "mins")" : ""
    case .seconds:
        let seconds = time % 60
        return seconds > 0 ? "\(seconds) \(seconds == 1 ? "second" : "seconds")" : ""
    }
}
