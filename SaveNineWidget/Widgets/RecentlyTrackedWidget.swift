//
//  RecentlyTrackedWidget.swift
//  SaveNineWidget
//
//  Created by Lawrence Horne on 12/18/22.
//

import SwiftUI
import WidgetKit

struct RecentlyTrackedProvider: TimelineProvider {
    func placeholder(in context: Context) -> RecentlyTrackedEntry {
        RecentlyTrackedEntry(date: .now, project: Project.preview)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (RecentlyTrackedEntry) -> ()) {
        if let project = Project.recentlyTracked {
            let entry = RecentlyTrackedEntry(date: .now, project: project)
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<RecentlyTrackedEntry>) -> ()) {
        if let project = Project.recentlyTracked {
            let entry = RecentlyTrackedEntry(date: .now, project: project)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct RecentlyTrackedEntry: TimelineEntry {
    let date: Date
    let project: Project
}

struct RecentlyTrackedEntryView: View {
    var entry: RecentlyTrackedProvider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            ProjectWidgetView(project: entry.project)
        case .accessoryRectangular:
            HStack {
                VStack(alignment: .leading) {
                    Text(entry.project.displayName)
                    HStack {
                        Image(systemName: "stopwatch")
                        Text(entry.project.timeTracked)
                    }
                    HStack {
                        Image(systemName: "calendar")
                        Text(entry.project.modificationDate!.relativeDescription())
                    }
                }
            }
            .widgetURL(createProjectUrl(id: entry.project.id!))
        case .systemMedium, .systemLarge, .systemExtraLarge, .accessoryCircular, .accessoryInline:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
}

struct RecentlyTrackedWidget: Widget {
    let kind: String = WidgetKind.RecentlyTracked.rawValue
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RecentlyTrackedProvider()) { entry in
            RecentlyTrackedEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    ContainerRelativeShape()
                        .fill(Color(red: 0.671, green: 0.949, blue: 0.604, opacity: 1.000).gradient)
                }
        }
        .configurationDisplayName("Project")
        .description("See the most recently tracked project and access it quickly.")
        .supportedFamilies([ .accessoryRectangular, .systemSmall])
    }
}

#Preview(as: .systemSmall) {
    RecentlyTrackedWidget()
} timeline: {
    RecentlyTrackedEntry(date: .now, project: Project.preview)
}



