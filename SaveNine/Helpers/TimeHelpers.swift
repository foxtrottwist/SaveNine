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
    
    switch format {
    case .hours:
        let hrs = hours(from: elapsedTime)
        return hrs <= 9 ? "0\(hrs)" : "\(hrs)"
    case .minutes:
        let mins = minutes(from: elapsedTime)
        return mins <= 9 ? "0\(mins)" : "\(mins)"
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

func longFormat(duration: Double) -> String {
    return format(duration: duration, in: .hours) + format(duration: duration, in: .minutes) + format(duration: duration, in: .seconds)
}

func format(duration: Double, in format: TimeValue) -> String {
    let time = Int(duration.rounded(.up))

    switch format {
    case .hours:
        let hrs = hours(from: time)
        return hrs > 0 ? "\(hrs) \(hrs == 1 ? "hr" : "hrs") " : ""
    case .minutes:
        let mins = minutes(from: time)
        return mins > 0 ? "\(mins) \(mins == 1 ? "min" : "mins") " : ""
    case .seconds:
        let secs = seconds(from: time)
        return secs > 0 ? "\(secs) \(secs == 1 ? "second" : "seconds")" : ""
    }
}

func hours(from elapseTime: Int) -> Int {
   return elapseTime / 60 / 60
}

func minutes(from elapseTime: Int) -> Int {
    let hours = elapseTime / 60 / 60
    return (elapseTime - (hours * 60 * 60)) / 60
}

func seconds(from elapseTime: Int) -> Int {
    return elapseTime % 60
}
