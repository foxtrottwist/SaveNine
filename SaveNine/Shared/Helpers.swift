//
//  Helpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 1/4/23.
//

import Foundation

/// Checks whether a the given directory exists and creates it if it does not.
/// - Parameter url: A file URL that specifies the directory to create.
   func createDirectoryIfNoneExist(at url: URL) {
       if !FileManager.default.fileExists(atPath: url.path()) {
           do {
               try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
           } catch {
               fatalError("Unable to create directory at \(url)")
           }
       }
   }

/// Creates URL for linking to the given project from the provided id.
/// - Parameter id: ID of the given project.
/// - Returns: An optional URL that may be passed to a link.
func projectUrl(id: UUID) -> URL? {
    return URL(string: "savenine://\(id)")
}
