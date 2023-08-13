//
//  FileManager+AppGroup.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/12/23.
//

import Foundation
import OSLog

enum AppGroupContainer: String {
    case groupID = "group.com.pawpawpixel.SaveNine"
}

extension FileManager {
    static var sharedContainer: URL {
        self.default.containerURL(forSecurityApplicationGroupIdentifier: AppGroupContainer.groupID.rawValue)!
    }
    
    /// Checks whether a the given directory exists and creates it if it does not.
    /// - Parameter url: A file URL that specifies the directory to create.
    static func createDirectoryIfNoneExist(at url: URL) {
        if !FileManager.default.fileExists(atPath: url.path()) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
            } catch {
                fatalError("Unable to create directory at \(url)")
            }
        }
    }
    
    static func deleteAppGroupContainerContents() {
        do {
            try FileManager.default.removeItem(at: sharedContainer)
            Logger.statistics.info("Files at \(sharedContainer) was deleted.")
        } catch let error as NSError {
            Logger.statistics.info("Could not delete files at \(sharedContainer): \(error)")
        }
    }
}
