//
//  SortOption.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/17/23.
//

import Foundation

enum SortOption: Identifiable, Codable, CaseIterable {
    case endDate
    case project
    
    var id: Self { self }
}

extension SortOption {
    var description: LocalizedStringResource {
        switch self {
        case .endDate:
            "End Date"
        case .project:
            "Project Name"
        }
    }
}
