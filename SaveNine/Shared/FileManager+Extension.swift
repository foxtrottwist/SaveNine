//
//  FileManager+Extension.swift
//  SaveNine
//
//  Created by Lawrence Horne on 1/4/23.
//

import Foundation
import SwiftUI

extension FileManager {
    static var sharedContainer: URL {
        self.default.containerURL(forSecurityApplicationGroupIdentifier: AppGroupContainer.groupID.rawValue)!
    }
    
    static var imageDirectory: URL {
        self.sharedContainer.appending(path: "Images")
    }
    
    static var widgetsDirectory: URL {
        self.sharedContainer.appending(path: AppGroupContainer.widgetDirectory.rawValue)
    }
    
    /// Retrieves an image from the App Groups container.
    /// - Parameter name: The name of the image file. The ".jpeg" extension is appended by the method.
    /// - Returns: The image retrieved or nil if there was no image found.
    static func getImage(named name: String) -> UIImage? {
        let url = self.imageDirectory.appending(path: appendFileExtension(to: name, using: .jpeg))
        
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
            
            let path = url.appending(path: appendFileExtension(to: name, using: .jpeg))
           
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
        let url = imageDirectory.appending(path: appendFileExtension(to: name, using: .jpeg))
           
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
    
    
    /// Retrieves and decodes data from the App Groups container to be displayed in a widget.
    /// - Parameters:
    ///   - type: The data structure Type that conforms to Decodable.
    ///   - file: The name of the file to be retrieved. The ".json" extension is appended by the method.
    /// - Returns: The decoded data structure.
    static func readWidgetData<T: Decodable>(_ type: T.Type, from file: String) -> T? {
        let url = self.widgetsDirectory.appending(path: appendFileExtension(to: file, using: .json))
        
        guard self.default.fileExists(atPath: url.path()) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
    
    
    /// Writes an Encodable date structure to the App Groups container.
    /// - Parameters:
    ///   - object: The data structure to be written.
    ///   - file: The name of the file to be written. The ".json" extension is appended by the method.
    static func writeWidget<T: Encodable>(data object: T, to file: String) {
        let url = self.widgetsDirectory
        createDirectoryIfNoneExist(at: url)
        
        let path = url.appending(path: appendFileExtension(to: file, using: .json))
        
        let encoder = JSONEncoder()
        let data = try? encoder.encode(object)
        
        do {
            try data?.write(to: path)
        } catch {
            print("Failed to write to \(path). Error: \(error.localizedDescription)")
        }
    }
    
    
    /// Checks whether a the given directory exists and creates it if it does not.
    /// - Parameter url: A file URL that specifies the directory to create.
    static func createDirectoryIfNoneExist(at url: URL) {
        if !self.default.fileExists(atPath: url.path()) {
             do {
                 try self.default.createDirectory(at: url, withIntermediateDirectories: false)
             } catch {
                 fatalError("Unable to create directory at \(url)")
             }
        }
    }
}
