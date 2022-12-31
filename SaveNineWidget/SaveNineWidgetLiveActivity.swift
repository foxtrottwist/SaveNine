//
//  SaveNineWidgetLiveActivity.swift
//  SaveNineWidget
//
//  Created by Lawrence Horne on 12/18/22.
//

import SwiftUI
import WidgetKit

struct SaveNineWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TrackerAttributes.self) { context in
            TimerLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.attributes.projectName)
                        .dynamicIsland(verticalPlacement: .belowIfTooWide)
                        .foregroundColor(Color(red: 0.671, green: 0.949, blue: 0.604, opacity: 1.000))
                        .frame(width: context.attributes.projectName.count < 10 ? 110 : 150)
                        .multilineTextAlignment(.leading)
                        .font(context.attributes.projectName.count < 10 ? .title : .headline)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.start, style: .timer)
                        .widgetTimer(width: 150)
                        .dynamicIsland(verticalPlacement: .belowIfTooWide)
                        .font(.largeTitle)
                        .foregroundColor(Color(red: 0.671, green: 0.949, blue: 0.604, opacity: 1.000))
                }
            } compactLeading: {
                Text("S9")
                    .foregroundColor(Color(red: 0.671, green: 0.949, blue: 0.604, opacity: 1.000))
            } compactTrailing: {
                Text(context.state.start, style: .timer)
                    .widgetTimer(width: 55)
                    .foregroundColor(Color(red: 0.671, green: 0.949, blue: 0.604, opacity: 1.000))
            } minimal: {
                Image(systemName: "stopwatch")
                    .foregroundColor(Color(red: 0.671, green: 0.949, blue: 0.604, opacity: 1.000))
            }
            .widgetURL(URL(string: "savenine://\(context.attributes.projectId)"))
            .keylineTint(Color(red: 0.671, green: 0.949, blue: 0.604, opacity: 1.000))
        }
    }
}
