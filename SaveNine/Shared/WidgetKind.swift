//
//  WidgetKind.swift
//  SaveNine
//
//  Created by Lawrence Horne on 1/4/23.
//

import Foundation

enum WidgetKind: String {
    case LastTracked
    
    var fileName: String {
        switch self {
        case .LastTracked:
            return lowerCaseFirstLetter(of: WidgetKind.LastTracked.rawValue)
        }
    }
    
    private func lowerCaseFirstLetter(of string: String) -> String {
        string.prefix(1).lowercased() + string.dropFirst()
    }
}
