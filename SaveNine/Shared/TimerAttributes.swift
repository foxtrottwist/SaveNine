//
//  TimerAttributes.swift
//  SaveNine
//
//  Created by Lawrence Horne on 12/18/22.
//

import ActivityKit
import Foundation

struct TimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var start: Date
    }

    // Fixed non-changing properties about your activity go here!
    var projectName: String
    var projectId: UUID
}
