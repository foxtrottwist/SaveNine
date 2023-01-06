//
//  QuickProject.swift
//  SaveNine
//
//  Created by Lawrence Horne on 1/3/23.
//

import Foundation

struct QuickProject: Codable {
    let id: UUID
    let name: String
    let image: String
    let modifiedDate: Date
    let sessionCount: Int
    let timeTracked: String
    
    static var example: QuickProject {
        .init(id: UUID(), name: "Lucy Loo", image: "", modifiedDate: Date(), sessionCount: 3, timeTracked: 3734.formattedDuration)
    }
}

