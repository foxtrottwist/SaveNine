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
}
