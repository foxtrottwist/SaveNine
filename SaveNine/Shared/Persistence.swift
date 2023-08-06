//
//  Persistence.swift
//  SaveNine
//
//  Created by Lawrence Horne on 8/5/23.
//

import SwiftData

public final class Persistence {}

public extension Persistence {
    static let container = try! ModelContainer(for: [Project.self, Session.self, Tag.self])
}
