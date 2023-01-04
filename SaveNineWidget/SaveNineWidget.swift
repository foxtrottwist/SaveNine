//
//  SaveNineWidget.swift
//  SaveNineWidget
//
//  Created by Lawrence Horne on 12/18/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), project: QuickProject.example, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let project = FileManager.readWidgetData(QuickProject.self, from: "lastTracked") ?? QuickProject.example
        
        let entry = SimpleEntry(date: Date(), project: project, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let project = FileManager.readWidgetData(QuickProject.self, from: "lastTracked") ?? QuickProject.example
        let entry = SimpleEntry(date: Date(), project: project, configuration: configuration)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let project: QuickProject
    let configuration: ConfigurationIntent
}

struct SaveNineWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.project.name)
            Text(entry.project.modifiedData)
            Text(entry.project.timeTracked)
        }
        .widgetURL(createProjectUrl(id: entry.project.id))
    }
}

struct SaveNineWidget: Widget {
    let kind: String = "LastTracked"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            SaveNineWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Last Tracked Project.")
        .description("See the details of the last project tracked and access it quickly.")
        .supportedFamilies([.systemSmall])
    }
}

struct SaveNineWidget_Previews: PreviewProvider {
    static var previews: some View {
        SaveNineWidgetEntryView(entry: SimpleEntry(date: Date(), project: QuickProject.example, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
