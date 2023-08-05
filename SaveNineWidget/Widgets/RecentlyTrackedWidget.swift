//
//  RecentlyTrackedWidget.swift
//  SaveNineWidget
//
//  Created by Lawrence Horne on 12/18/22.
//

import WidgetKit
import SwiftUI
import Intents

struct RecentlyTrackedProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> RecentlyTrackedEntry {
        RecentlyTrackedEntry(date: Date(), project: Project.preview, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (RecentlyTrackedEntry) -> ()) {
        if let project = Project.mostRecentlyTracked {
            let entry = RecentlyTrackedEntry(date: Date(), project: project, configuration: configuration)
            completion(entry)
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<RecentlyTrackedEntry>) -> ()) {
        if let project = Project.mostRecentlyTracked {
            let startOfDay = Calendar.current.startOfDay(for: Date())
            let entry = RecentlyTrackedEntry(date: startOfDay, project: project, configuration: configuration)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct RecentlyTrackedEntry: TimelineEntry {
    let date: Date
    let project: Project
    let configuration: ConfigurationIntent
}

struct RecentlyTrackedEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: RecentlyTrackedProvider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            RecentlyTrackedView(project: entry.project)
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
                Spacer()
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
    let kind: String = WidgetKind.MostRecentlyTracked.rawValue

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: RecentlyTrackedProvider()) { entry in
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

#Preview {
    RecentlyTrackedEntryView(entry: RecentlyTrackedEntry(date: Date(), project: Project.preview, configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
}


