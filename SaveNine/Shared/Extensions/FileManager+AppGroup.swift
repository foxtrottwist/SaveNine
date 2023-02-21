//
//  FileManager+AppGroup.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/12/23.
//

import Foundation

enum AppGroupContainer: String {
    case groupID = "group.com.pawpawpixel.SaveNine"
    case imageDirectory = "Images"
    case widgetDirectory = "Widgets"
}

extension FileManager {
    static var sharedContainer: URL {
        self.default.containerURL(forSecurityApplicationGroupIdentifier: AppGroupContainer.groupID.rawValue)!
    }
    
    static func deleteAppGroupContainerContents() {
        do {
            try FileManager.default.removeItem(at: sharedContainer)
            print("Files at \(sharedContainer) was deleted.")
        } catch let error as NSError {
            print("Could not delete files at \(sharedContainer): \(error)")
        }
    }
}
