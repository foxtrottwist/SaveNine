//
//  Helpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 1/4/23.
//

import Foundation

enum AppGroupContainer: String {
    case groupID = "group.com.pawpawpixel.SaveNine"
    case imageDirectory = "Images"
    case widgetDirectory = "Widgets"
}

enum FileExtension: String {
    case jpeg = ".jpeg"
    case json = ".json"
    case png = ".png"
}

/// Appends a chosen file extension used within the project to the given file name.
/// - Parameters:
///   - file: The Name of the file that will have the extension appending.
///   - using: The extension to use.
/// - Returns: The complete file name with the extension appended.
func appendFileExtension(to name: String, using ext: FileExtension) -> String {
    switch ext {
    case .jpeg:
        return name + FileExtension.jpeg.rawValue
    case .json:
        return name + FileExtension.json.rawValue
    case .png:
        return name + FileExtension.png.rawValue
    }
}

/// Creates URL for linking to the given project from the provided id.
/// - Parameter id: ID of the given project.
/// - Returns: An optional URL that may be passed to a link.
func createProjectUrl(id: UUID) -> URL? {
    return URL(string: "savenine://\(id)")
}
