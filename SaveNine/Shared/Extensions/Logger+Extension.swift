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
    
    /// Logs related to fetching, saving, sharing or exporting and importing data.
    static let data = Logger(subsystem: subsystem, category: "Data")
    /// Logs related to file management.
    static let fileManger = Logger(subsystem: subsystem, category: "FileManger")
    /// Logs related to tracking and analytics.
    static let statistics = Logger(subsystem: subsystem, category: "Statistics")
    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "ViewCycle")
}
