//
//  ProjectTimelineProvider.swift.swift
//  SaveNineWidgetExtension
//
//  Created by Lawrence Horne on 8/8/23.
//

import WidgetKit

struct ProjectTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> ProjectEntry {
        return ProjectEntry(date: .now, project: .init(name: "Lucy Loo"))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ProjectEntry) -> ()) {
        if let project = Project.recentlyTracked {
            completion(ProjectEntry(date: .now, project: project))
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ProjectEntry>) -> ()) {
        if let project = Project.recentlyTracked {
            let entry = ProjectEntry(date: project.projectSessions.first?.startDate! ?? .now, project: project)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct ProjectEntry: TimelineEntry {
    var date: Date
    var project: Project?
}
