//
//  ProjectWidget.swift
//  SaveNineWidget
//
//  Created by Lawrence Horne on 12/18/22.
//

import SwiftData
import SwiftUI
import WidgetKit

struct ProjectProvider: AppIntentTimelineProvider {
    let modelContext = ModelContext(Persistence.container)
    
    func project(for configuration: ProjectWidgetIntent) -> Project? {
        if let id = configuration.project?.id {
            try? modelContext.fetch(
                FetchDescriptor<Project>(predicate: #Predicate { $0.id == id })
            ).first
        } else if configuration.recentlyTracked {
            Project.recentlyTracked
        } else {
            nil
        }
    }
    
    func placeholder(in context: Context) -> ProjectEntry {
        return ProjectEntry(date: .now, project: .init(name: "Lucy Loo"))
    }
    
    func snapshot(for configuration: ProjectWidgetIntent, in context: Context) async -> ProjectEntry {
        if let project = project(for: configuration) {
            ProjectEntry(date: .now, project: project)
        } else {
            .empty
        }
    }
    
    func timeline(for configuration: ProjectWidgetIntent, in context: Context)async -> Timeline<ProjectEntry> {
        if let project = project(for: configuration) {
            Timeline(entries: [ProjectEntry(date: .now, project: project)], policy: .atEnd)
        } else {
            Timeline(entries: [.empty], policy: .never)
        }
    }
}

struct ProjectEntry: TimelineEntry {
    let date: Date
    let project: Project
    
    static var empty: Self {
        Self(date: .now, project: .init(name: ""))
    }
}

struct RecentlyTrackedEntryView: View {
    var entry: ProjectProvider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall, .systemMedium:
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
                        if let modificationDate = entry.project.modificationDate {
                            Text(modificationDate.relativeDescription())
                        } else {
                            Text("–––")
                        }
                    }
                }
            }
            .widgetURL(createProjectUrl(id: entry.project.id!))
        case .systemLarge, .systemExtraLarge, .accessoryCircular, .accessoryInline:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
}

struct ProjectWidget: Widget {
    let kind: String = WidgetKind.RecentlyTracked.rawValue
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ProjectWidgetIntent.self, provider: ProjectProvider()) { entry in
            RecentlyTrackedEntryView(entry: entry)
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



