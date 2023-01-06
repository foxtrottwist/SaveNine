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
        LastTrackedEntry(date: Date(), project: QuickProject.example, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (LastTrackedEntry) -> ()) {
        let project = FileManager.readWidgetData(QuickProject.self, from: S9WidgetKind.LastTracked.fileName) ?? QuickProject.example
        
        let entry = LastTrackedEntry(date: Date(), project: project, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let project = FileManager.readWidgetData(QuickProject.self, from: S9WidgetKind.LastTracked.fileName) ?? QuickProject.example
        let entry = LastTrackedEntry(date: Date(), project: project, configuration: configuration)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct LastTrackedEntry: TimelineEntry {
    let date: Date
    let project: QuickProject
    let configuration: ConfigurationIntent
}

struct LastTrackedWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(entry.project.name)
                        .font(.title3)
                        .foregroundColor(Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000))
                        .lineLimit(2)
                        .padding(2)
                    
                    Text(entry.project.timeTracked)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(entry.project.modifiedDate.widgetFormattedDate)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .fontWeight(.medium)
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
        LastTrackedWidgetEntryView(entry: LastTrackedEntry(date: Date(), project: QuickProject.example, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


