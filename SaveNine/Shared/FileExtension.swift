//
//  FileExtension.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/15/23.
//

import Foundation

enum FileExtension: String {
    case jpeg = ".jpeg"
    case json = ".json"
    case png = ".png"
    
    /// Appends a chosen file extension used within the project to the given file name.
    /// - Parameters:
    ///   - file: The Name of the file that will have the extension appending.
    ///   - using: The extension to use.
    /// - Returns: The complete file name with the extension appended.
    static func append(to name: String, using ext: Self) -> String {
        switch ext {
        case .jpeg:
            return name + FileExtension.jpeg.rawValue
        case .json:
            return name + FileExtension.json.rawValue
        case .png:
            return name + FileExtension.png.rawValue
        }
    }
}
