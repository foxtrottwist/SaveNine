//
//  Marker.swift
//  SaveNine
//
//  Created by Lawrence Horne on 11/21/23.
//

import Foundation
import SwiftData

@Model
class Marker {
    public var id: UUID?
    var lastUsed: Date?
    var name: String?
    
    init(id: UUID? = UUID(), lastUsed: Date? = nil, name: String? = nil) {
        self.id = id
        self.lastUsed = lastUsed
        self.name = name
    }
}

extension Marker {
    static var preview: Marker {
        .init(name: "Quilting")
    }
}
