//
//  S9WidgetKind.swift
//  SaveNine
//
//  Created by Lawrence Horne on 1/4/23.
//

import Foundation

enum S9WidgetKind: String {
    case LastTracked
    
    var fileName: String {
        switch self {
        case .LastTracked:
            return lowerCaseFirstLetter(of: S9WidgetKind.LastTracked.rawValue)
        }
    }
    
    private func lowerCaseFirstLetter(of string: String) -> String {
        string.prefix(1).lowercased() + string.dropFirst()
    }
}
