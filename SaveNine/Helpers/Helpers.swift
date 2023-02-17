//
//  Helpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/13/22.
//

import Foundation

/// Deletes a file in the user's document directory if one is found with the provided name.
/// - Parameter name: The name of the file to deletes.
func deleteFile(named name: String) {
    guard !name.isEmpty else { return }
    let url = URL.documentsDirectory.appending(path: name)
       
    guard FileManager.default.fileExists(atPath: url.path()) else {
           print("File does not exist at path: \(url)")
           return
       }
       
       do {
           try FileManager.default.removeItem(at: url)
           print("\(name) was deleted.")
       } catch let error as NSError {
           print("Could not delete \(name): \(error)")
       }
}

