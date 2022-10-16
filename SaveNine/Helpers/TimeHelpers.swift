//
//  TimeHelpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/18/22.
//

import Foundation

/// Describes the way a given numeric value should be represented.
enum TimeValue {
    case hours, minutes, seconds
}

/// Creates a representation of elapsed time from a given date until now in a chosen format.
/// - Parameters:
///   - start: The start date of the elapsed time.
///   - format: How the elapsed time should be formatted.
/// - Returns: A double digit string representing the elapsed time.
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

/// Creates the appropriate string representation of seconds for a given amount time.
/// - Parameter seconds: A amount of time in seconds.
/// - Returns: A double digit string representing the elapsed time.
func seconds(_ seconds: Int) -> String {
    if seconds > 60 {
        let remainder = seconds % 60
        return remainder <= 9 ? "0\(remainder)" : "\(remainder)"
    } else if seconds > 9 {
        return "\(seconds)"
    }
    
    return "0\(seconds)"
}

/// Formats a duration in hours, minutes and seconds.
/// - Parameter duration: The duration to be formatted.
/// - Returns: A string of the formatted duration.
func longFormat(duration: Double) -> String {
    return format(duration: duration, in: .hours) + format(duration: duration, in: .minutes) + format(duration: duration, in: .seconds)
}

/// Formats a duration in a chosen format.
/// - Parameters:
///   - duration: The duration to be formatted.
///   - format: How the duration should be formatted.
/// - Returns: A string of the formatted duration.
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

/// Returns the amount of hours for a given amount of time.
/// - Parameter elapseTime: The amount of time from which to calculate hours.
/// - Returns: The number of hours calculated.
func hours(from elapseTime: Int) -> Int {
   return elapseTime / 60 / 60
}

/// Returns the amount of minutes over and beyond any whole hours in a given amount of time.
/// - Parameter elapseTime: The amount of time from which to calculate minutes.
/// - Returns: The number of minutes calculated.
func minutes(from elapseTime: Int) -> Int {
    let hours = hours(from: elapseTime)
    return (elapseTime - (hours * 60 * 60)) / 60
}

/// Returns the amount of seconds over and beyond any whole hours or minutes in a given amount of time.
/// - Parameter elapseTime: The amount of time from which to calculate seconds.
/// - Returns: The number of seconds calculated.
func seconds(from elapseTime: Int) -> Int {
    return elapseTime % 60
}
