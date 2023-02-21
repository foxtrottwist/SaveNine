//
//  AppIcon.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/20/23.
//

import Foundation

enum AppIcon: String, CaseIterable {
    case defaultIcon = "AppIcon"
    case pawpawPink = "AppIcon-2"
    
    var descriptor: String {
        switch self {
        case .defaultIcon:
            return "Default Icon"
        case .pawpawPink:
            return "Pawpaw Pink"
        }
    }
}
