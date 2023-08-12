//
//  ProjectWidget.swift
//  SaveNineWidget
//
//  Created by Lawrence Horne on 12/18/22.
//

import SwiftUI
import WidgetKit

struct ProjectWidget: Widget {
    let kind: String = WidgetKind.recentlyTracked.rawValue
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ProjectTimelineProvider()) { entry in
            ProjectWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    ContainerRelativeShape()
                        .fill(Color(red: 0.671, green: 0.949, blue: 0.604, opacity: 1.000).gradient)
                }
        }
        .configurationDisplayName("Project")
        .description("See the most recently tracked project and access it quickly.")
        .supportedFamilies([ .accessoryRectangular, .systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    ProjectWidget()
} timeline: {
    ProjectEntry(date: .now, project: Project.preview)
}



