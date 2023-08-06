//
//  ProjectWidgetView.swift
//  SaveNineWidgetExtension
//
//  Created by Lawrence Horne on 1/16/23.
//

import SwiftUI
import WidgetKit

struct ProjectWidgetView: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(project.displayName)
                .font(.caption)
                .foregroundStyle(.black)
                .lineLimit(2)
            
            Text(project.timeTracked)
                .font(.title)
                .minimumScaleFactor(0.8)
            
            Text(project.modificationDate!.relativeDescription())
                .foregroundStyle(.black.opacity(0.5))
                .font(.caption)
            
            Spacer()
            
            Button(intent: StartTimer(project: ProjectEntity(from: project))) {
                if project.tracking {
                    Image(systemName: "stop.fill")
                    Text(.now, style: .timer)
                        .font(.caption)
                } else {
                    Label("Start", systemImage: "play.fill")
                        .font(.caption)
                }
            }
        }
        .fontWeight(.medium)
        .foregroundStyle(.black.opacity(0.7))
        .frame(maxWidth: .infinity, alignment: .leading)
        .widgetURL(createProjectUrl(id: project.id!))
    }
}

#Preview {
    ProjectWidgetView(project: Project.preview)
        .previewContext(WidgetPreviewContext(family: .systemSmall))
}
