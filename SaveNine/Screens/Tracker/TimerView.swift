//
//  TimerView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/18/22.
//

import SwiftUI

struct TimerView: View {
    let start: Date?
    
    var body: some View {
        if let start = start {
            TimelineView(.periodic(from: start, by: 1)) { _ in
                Text(.seconds(-start.timeIntervalSinceNow), format: .time(pattern: .hourMinuteSecond(padHourToLength: 2)))
                .font(.largeTitle)
                .monospacedDigit()
                .padding()
            }
        } else {
            Text(.seconds(0), format: .time(pattern: .hourMinuteSecond(padHourToLength: 2)))
            .font(.largeTitle)
            .monospacedDigit()
            .padding()
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(start: Date())
    }
}
