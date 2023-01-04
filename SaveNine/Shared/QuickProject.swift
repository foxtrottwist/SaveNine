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
    let modifiedData: String
    let sessionCount: Int
    let timeTracked: String
    
    static var example: QuickProject {
        .init(id: UUID(), name: "Lucy Loo", modifiedData: Data().description, sessionCount: 3, timeTracked: 3600.description)
    }
}

