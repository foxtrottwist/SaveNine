//
//  FetchPredicate.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/14/23.
//

import Foundation

enum FetchPredicate: String {
    case closed = "closed = %d"
    case search = "name CONTAINS[c] %@"
    case tags = "%@ IN tags.name"
    case label = "label = %@"
    
    static func create(from predicates: [(Self, CVarArg)?]) -> NSPredicate {
        let predicates = predicates.compactMap({ $0 }).map { NSPredicate(format: $0.0.rawValue, $0.1) }
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
}
