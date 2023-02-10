//
//  SessionLabel.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/6/23.
//

import Foundation

struct SessionLabel: Codable, Identifiable {
    let id: UUID
    let name: String
    let lastUsed: Date
    
    static var Example: SessionLabel {
        .init(id: UUID(), name: "Quilting", lastUsed: Date())
    }
    
    static var Examples: [SessionLabel] {
        [
            .init(id: UUID(), name: "Cutting", lastUsed: Date()),
            .init(id: UUID(), name: "Designing", lastUsed: Date()),
            .init(id: UUID(), name: "Influencing", lastUsed: Date()),
            .init(id: UUID(), name: "Quilting", lastUsed: Date()),
        ]
    }
}
