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
            TimerActivityLockScreenView(context: context)
                .widgetURL(createProjectUrl(id: context.attributes.projectId))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Spacer()
                    Text(context.attributes.projectName)
                        .dynamicIsland(verticalPlacement: .belowIfTooWide)
                        .foregroundColor(Color(red: 0.671, green: 0.949, blue: 0.604, opacity: 1.000))
                        .font(.headline)
                    Spacer()
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Spacer()
                    Text(context.state.start, style: .timer)
                        .widgetTimer(width: 150, height: 10)
                        .dynamicIsland(verticalPlacement: .belowIfTooWide)
                        .font(.title)
                        .foregroundColor(Color(red: 0.671, green: 0.949, blue: 0.604, opacity: 1.000))
                    Spacer()
                }
            } compactLeading: {
                Image(systemName: "stopwatch")
                    .foregroundColor(Color(red: 0.671, green: 0.949, blue: 0.604, opacity: 1.000))
            } compactTrailing: {
                Text(context.state.start, style: .timer)
                    .widgetTimer(width: 55)
                    .foregroundColor(Color(red: 0.671, green: 0.949, blue: 0.604, opacity: 1.000))
            } minimal: {
                Image(systemName: "stopwatch")
                    .foregroundColor(Color(red: 0.671, green: 0.949, blue: 0.604, opacity: 1.000))
            }
            .widgetURL(createProjectUrl(id: context.attributes.projectId))
            .keylineTint(Color(red: 0.671, green: 0.949, blue: 0.604, opacity: 1.000))
        }
    }
}
