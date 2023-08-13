//
//  Helpers.swift
//  SaveNine
//
//  Created by Lawrence Horne on 1/4/23.
//

import Foundation

/// Creates URL for linking to the given project from the provided id.
/// - Parameter id: ID of the given project.
/// - Returns: An optional URL that may be passed to a link.
func projectURL(id: UUID) -> URL? {
    return URL(string: "savenine://\(id)")
}
