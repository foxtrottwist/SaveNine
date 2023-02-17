//
//  SortOption.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/17/23.
//

import Foundation

enum SortOption: Codable {
    case creationDate, name, project, startDate
    
    var descriptor: String {
        switch self {
        case .creationDate:
            return "Creation Date"
        case .name:
            return "Title"
        case .project:
            return "Project"
        case .startDate:
            return "Start Date"
        }
    }
   
    var orderAscending: (descriptor: String, value: Bool) {
        switch self {
        case .creationDate, .startDate:
            return ("Oldest First", true)
        case .name, .project:
            return ("Ascending", true)
        }
    }
    
    var orderDescending: (descriptor: String, value: Bool) {
        switch self {
        case .creationDate, .startDate:
            return ("Newest First", false)
        case .name, .project:
            return ("Descending", false)
        }
    }
}
