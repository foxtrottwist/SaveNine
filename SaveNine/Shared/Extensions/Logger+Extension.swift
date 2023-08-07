//
//  Logger+Extension.swift
//  SaveNine
//
//  Created by Lawrence Horne on 8/7/23.
//

import OSLog

extension Logger {
    /// Using bundle identifier to a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    /// All logs related to tracking and analytics.
    static let statistics = Logger(subsystem: subsystem, category: "statistics")
    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")
}
