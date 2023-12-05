//
//  ProjectWidgetView.swift
//  SaveNineWidgetExtension
//
//  Created by Lawrence Horne on 1/16/23.
//

import OSLog
import SwiftUI
import WidgetKit


struct ProjectWidgetView: View {
    var entry: ProjectEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        if let project = entry.project {
            switch family {
            case .systemSmall:
                ProjectSnapshotView(project: project)
            case .accessoryRectangular:
                HStack {
                    VStack(alignment: .leading) {
                        Text(project.name)
                        HStack {
                            Image(systemName: "stopwatch")
                            Text(project.timeTracked)
                        }
                        HStack {
                            Image(systemName: "calendar")
                            if let modificationDate = project.modificationDate {
                                Text(modificationDate.relativeDescription())
                            } else {
                                Text("–––")
                            }
                        }
                    }
                }
                .widgetURL(projectURL(id: project.id!))
            case .systemMedium, .systemLarge, .systemExtraLarge, .accessoryCircular, .accessoryInline:
                EmptyView()
            @unknown default:
                EmptyView()
            }
        } else {
            ContentUnavailableView {
                Image(systemName: "stopwatch")
                Text("Start tracking projects in Save Nine.")
                    .font(.caption)
            }
        }
    }
}


struct ProjectSnapshotView: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(project.name)
                .font(.caption)
                .foregroundStyle(.black)
                .lineLimit(2)
            
            if project.tracking ?? false {
                timer
            } else {
                info
            }
            
            Spacer()
            
            HStack {
                Button(intent: ToggleTimer(project: ProjectEntity(from: project))) {
                    Group {
                        if project.tracking ?? false {
                            Label("Stop", systemImage: "stop.fill")
                        } else {
                            Label("Start", systemImage: "play.fill")
                        }
                    }
                    .font(.caption)
                }
                .disabled(project.name.isEmpty)
            }
        }
        .fontWeight(.medium)
        .foregroundStyle(.black.opacity(0.7))
        .frame(maxWidth: .infinity, alignment: .leading)
        .widgetURL(projectURL(id: project.id!))
    }
    
    @ViewBuilder
    var info: some View {
        Text(project.timeTracked)
            .font(.title)
        
        Group {
            if let modificationDate = project.modificationDate {
                Text(modificationDate.relativeDescription())
            } else {
                Text("–––")
            }
        }
        .foregroundStyle(.black.opacity(0.5))
        .font(.caption)
    }
    
    @ViewBuilder
    var timer: some View {
        HStack {
            Spacer()
            Text(project.projectSessions.first?.startDate ?? .now, style: .timer)
                .font(.title)
            Spacer()
        }
        .invalidatableContent()
    }
}
