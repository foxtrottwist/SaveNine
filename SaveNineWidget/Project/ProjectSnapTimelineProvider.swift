//
//  ProjectSnapTimelineProvider.swift
//  SaveNineWidgetExtension
//
//  Created by Lawrence Horne on 8/8/23.
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
            Timeline(
                entries: [ProjectEntry(
                    date: project.projectSessions.first?.startDate! ?? .now,
                    project: project
                )],
                policy: .atEnd
            )
        } else {
            Timeline(entries: [.empty], policy: .never)
        }
    }
}

struct ProjectEntry: TimelineEntry {
    var date: Date
    var project: Project?
    
    static var empty: Self {
        Self(date: .now)
    }
}
