//
//  Project.swift
//  SaveNine
//
//  Created by Lawrence Horne on 8/1/23.
//
//

import Foundation
import SwiftData

@Model
public class Project {
    var closed: Bool?
    var creationDate: Date?
    var detail: String?
    var id: UUID?
    var image: String?
    var modificationDate: Date?
    var name: String?
    @Relationship(.cascade, inverse: \Session.project) var sessions: [Session]?
    @Relationship(inverse: \Tag.projects) var tags: [Tag]?

    init(closed: Bool? = nil, creationDate: Date? = nil, detail: String? = nil, id: UUID? = nil, image: String? = nil, modificationDate: Date? = nil, name: String? = nil, sessions: [Session]? = nil, tags: [Tag]? = nil) {
        self.closed = closed
        self.creationDate = creationDate
        self.detail = detail
        self.id = id
        self.image = image
        self.modificationDate = modificationDate
        self.name = name
        self.sessions = sessions
        self.tags = tags
    }
}
