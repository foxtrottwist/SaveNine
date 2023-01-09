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
    
//    var image: Image {
//        let uiImage = FileManager.getImage(named: entry.project.image)!
//        let image = Image(uiImage: uiImage)
//        return image
//    }

    var body: some View {
        ZStack {
//            ContainerRelativeShape()
//                .fill(Color(red: 0.671, green: 0.949, blue: 0.604, opacity: 1.000).gradient)
//                .opacity(0.25)
            
//            if let uiImage = FileManager.getImage(named: entry.project.image), let image = Image(uiImage: uiImage) {
//                image
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 160, height: 160)
//                    .opacity(0.2)
//            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text(entry.project.name)
                        .font(.headline)
                        .lineLimit(2)
                        .padding(1)
                    
                    Text(entry.project.timeTracked)
                        .font(.callout)
                    
                    Spacer()
                    
                    Text(entry.project.modifiedDate.widgetFormattedDate)
                        .font(.footnote)
                }
                .foregroundColor(.black.opacity(0.7))
                .fontWeight(.medium)
                .padding()
                
                Spacer()
            }
        }
        .background(content: {
            ZStack {
                ContainerRelativeShape()
                    .fill(Color(red: 0.671, green: 0.949, blue: 0.604, opacity: 1.000).gradient)
                    
                if let uiImage = FileManager.getImage(named: entry.project.image), let image = Image(uiImage: uiImage) {
                    image
                        .resizable()
                        .scaledToFill()
                        .opacity(0.2)
                }
            }
        })
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


