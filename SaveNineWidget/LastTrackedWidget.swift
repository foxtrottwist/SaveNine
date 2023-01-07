//
//  LastTrackedWidget.swift
//  SaveNineWidget
//
//  Created by Lawrence Horne on 12/18/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> LastTrackedEntry {
        LastTrackedEntry(date: Date(), project: ProjectWidget.example, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (LastTrackedEntry) -> ()) {
        let project = FileManager.readWidgetData(ProjectWidget.self, from: S9WidgetKind.LastTracked.fileName) ?? ProjectWidget.example
        
        let entry = LastTrackedEntry(date: Date(), project: project, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let project = FileManager.readWidgetData(ProjectWidget.self, from: S9WidgetKind.LastTracked.fileName) ?? ProjectWidget.example
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let entry = LastTrackedEntry(date: startOfDay, project: project, configuration: configuration)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct LastTrackedEntry: TimelineEntry {
    let date: Date
    let project: ProjectWidget
    let configuration: ConfigurationIntent
}

struct LastTrackedWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(Color(red: 0.671, green: 0.949, blue: 0.604, opacity: 1.000).gradient)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(entry.project.name)
                        .font(.callout)
                        .lineLimit(2)
                        .padding(1)
                    
                    Text(entry.project.timeTracked)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("last tracked:")
                        .font(.caption)
                        .italic()
                    
                    Text(entry.project.modifiedDate.relativeDescription())
                        .font(.subheadline)
                }
                .fontWeight(.medium)
                .foregroundColor(.black.opacity(0.6))
                .padding()
                
                Spacer()
            }
        }
        .widgetURL(createProjectUrl(id: entry.project.id))
    }
}

struct LastTrackedWidget: Widget {
    let kind: String = S9WidgetKind.LastTracked.rawValue

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            LastTrackedWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Project")
        .description("See the most recently tracked project and access it quickly.")
        .supportedFamilies([.systemSmall])
    }
}

struct LastTrackedWidget_Previews: PreviewProvider {
    static var previews: some View {
        LastTrackedWidgetEntryView(entry: LastTrackedEntry(date: Date(), project: ProjectWidget.example, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


