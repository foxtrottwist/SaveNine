//
//  Tag.swift
//  SaveNine
//
//  Created by Lawrence Horne on 8/1/23.
//
//

import Foundation
import SwiftData

@Model
public class Tag {
    public var id: UUID?
    var name: String?
    var projects: [Project]?

    init(id: UUID? = UUID(), name: String?, projects: [Project]? = []) {
        self.id = id
        self.name = name
        self.projects = projects
    }
}

extension Tag {
    var displayName: String {
        name ?? ""
    }
    
    static var preview: Tag {
        .init(name: "fpp", projects: [Project.preview])
    }
}
