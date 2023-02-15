//
//  FileManager+Images.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/12/23.
//

import Foundation
import SwiftUI

extension FileManager {
    static var imageDirectory: URL {
        self.sharedContainer.appending(path: "Images")
    }
    
    /// Retrieves an image from the App Groups container.
    /// - Parameter name: The name of the image file. The ".jpeg" extension is appended by the method.
    /// - Returns: The image retrieved or nil if there was no image found.
    static func getImage(named name: String) -> UIImage? {
        let url = self.imageDirectory.appending(path: FileExtension.append(to: name, using: .jpeg))
        
        guard self.default.fileExists(atPath: url.path()) else {
            print("Image does not exist at path: \(url)")
               return nil
           }
        
        if let uiImage = UIImage(contentsOfFile: url.path()) {
               return uiImage
           } else {
               print("UIImage could not be created.")
               return nil
           }
    }
    
    /// Saves an UIImage as a jpeg to the App Groups container.
    /// - Parameters:
    ///   - uiImage: The UIImage to save.
    ///   - name: The name of the image file. The ".jpeg" extension is appended by the method.
    static func save(uiImage: UIImage, named name: String) {
        if let data = uiImage.jpegData(compressionQuality: 0.8) {
            let url = self.imageDirectory
            
            createDirectoryIfNoneExist(at: url)
            let path = url.appending(path: FileExtension.append(to: name, using: .jpeg))
           
            do {
                try data.write(to: path)
            } catch {
                print("Failed to write to \(path)")
            }
        }
    }
    
    /// Deletes an image in the App Groups container if one is found with the provided name.
    /// - Parameter name: The name of the file to delete. The ".jpeg" extension is appended by the method.
    static func deleteImage(named name: String) {
        guard !name.isEmpty else { return }
        let url = imageDirectory.appending(path: FileExtension.append(to: name, using: .jpeg))
           
        guard self.default.fileExists(atPath: url.path()) else {
               print("File does not exist at path: \(url)")
               return
           }
           
           do {
               try self.default.removeItem(at: url)
           } catch let error as NSError {
               print("Could not delete \(name): \(error)")
           }
    }
}
