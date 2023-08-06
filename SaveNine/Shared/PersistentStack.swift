//
//  PersistentStack.swift
//  SaveNine
//
//  Created by Lawrence Horne on 8/5/23.
//

import Foundation
import SwiftData

public final class PersistentStack {}

public extension PersistentStack {
    static let container = try! ModelContainer(for: [Project.self, Session.self, Tag.self])
}
