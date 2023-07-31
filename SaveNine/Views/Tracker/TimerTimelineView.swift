//
//  TimerTimelineView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/18/22.
//

import SwiftUI

struct TimerTimelineView: View {
    let start: Date?
    
    var body: some View {
        if let start = start {
            TimelineView(.periodic(from: start, by: 1)) { _ in
                Text(start.timeIntervalSinceNow.timerFormattedDuration)
                    .monospacedDigit()
            }
        } else {
            Text(0.formattedDuration)
                .monospacedDigit()
        }
    }
}

#Preview {
    TimerTimelineView(start: Date())
}
