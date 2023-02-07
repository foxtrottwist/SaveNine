//
//  DocumentHelpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/13/22.
//

import Foundation
import SwiftUI

/// Saves an UIImage as a jpeg to the user's document directory.
/// - Parameters:
///   - uiImage: The UIImage to save.
///   - name: The name of the image file.
func save(uiImage: UIImage, named name: String) {
        if let data = uiImage.jpegData(compressionQuality: 0.8) {
            let url = URL.documentsDirectory.appending(path: name)
            try? data.write(to: url)
        }
}

/// Retrieves an image from the user's document directory.
/// - Parameter name: The name of the image file.
/// - Returns: The image retrieved or nil if there was no name found for the name provided.
func getImage(named name: String) -> UIImage? {
    let path = URL.documentsDirectory.appending(path: name).path()
    
    guard FileManager.default.fileExists(atPath: path) else {
           print("Image does not exist at path: \(path)")
           return nil
       }
    
    if let uiImage = UIImage(contentsOfFile: path) {
           return uiImage
       } else {
           print("UIImage could not be created.")
           return nil
       }
}

/// Deletes a file in the user's document directory if one found with the provided name.
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

