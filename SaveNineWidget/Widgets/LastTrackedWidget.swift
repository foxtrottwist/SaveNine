//
//  LastTrackedWidget.swift
//  SaveNineWidget
//
//  Created by Lawrence Horne on 12/18/22.
//

import WidgetKit
import SwiftUI
import Intents

struct LastTrackedProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> LastTrackedEntry {
        LastTrackedEntry(date: Date(), project: Project.preview, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (LastTrackedEntry) -> ()) {
        if let project = Project.mostRecentlyTracked {
            let entry = LastTrackedEntry(date: Date(), project: project, configuration: configuration)
            completion(entry)
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        if let project = Project.mostRecentlyTracked {
            let startOfDay = Calendar.current.startOfDay(for: Date())
            let entry = LastTrackedEntry(date: startOfDay, project: project, configuration: configuration)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct LastTrackedEntry: TimelineEntry {
    let date: Date
    let project: Project
    let configuration: ConfigurationIntent
}

struct LastTrackedEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: LastTrackedProvider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            LastTrackedView(project: entry.project)
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

struct LastTrackedWidget: Widget {
    let kind: String = S9WidgetKind.LastTracked.rawValue

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: LastTrackedProvider()) { entry in
            LastTrackedEntryView(entry: entry)
        }
        .configurationDisplayName("Project")
        .description("See the most recently tracked project and access it quickly.")
        .supportedFamilies([ .accessoryRectangular, .systemSmall])
    }
}

#Preview {
    LastTrackedEntryView(entry: LastTrackedEntry(date: Date(), project: Project.preview, configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
}


