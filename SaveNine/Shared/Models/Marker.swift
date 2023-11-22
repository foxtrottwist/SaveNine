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
    
    init(id: UUID? = UUID(), lastUsed: Date? = nil, name: String?) {
        self.id = id
        self.lastUsed = lastUsed
        self.name = name
    }
}

extension Marker {
    var displayName: String {
        name ?? ""
    }
    
    static var preview: Marker {
        .init(name: "Quilting")
    }
    
    static func updateLastUsed(for name: String) {
        let modelContext = ModelContext(Persistence.container)
        let marker = try? modelContext.fetch(FetchDescriptor<Marker>(predicate: #Predicate { $0.name == name })).first
        marker?.lastUsed = .now
        try! modelContext.save()
    }
}
