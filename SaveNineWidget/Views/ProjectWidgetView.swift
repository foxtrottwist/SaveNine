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
           
            if project.tracking {
                timer
            } else {
                info
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button(intent: StartTimer(project: ProjectEntity(from: project))) {
                    Group {
                        if project.tracking {
                            Label("Stop", systemImage: "stop.fill")
                        } else {
                            Label("Start", systemImage: "play.fill")
                        }
                    }
                    .font(.caption)
                    .padding([.leading, .trailing])
                }
                Spacer()
            }
        }
        .fontWeight(.medium)
        .foregroundStyle(.black.opacity(0.7))
        .frame(maxWidth: .infinity, alignment: .leading)
        .widgetURL(createProjectUrl(id: project.id!))
    }
    
    @ViewBuilder
    var info: some View {
        Text(project.timeTracked)
            .font(.title)
        
        Text(project.modificationDate!.relativeDescription())
            .foregroundStyle(.black.opacity(0.5))
            .font(.caption)
    }
    
    @ViewBuilder
    var timer: some View {
        HStack {
            Spacer()
            Text(.now, style: .timer)
                .font(.title)
            Spacer()
        }
    }
}

#Preview {
    ProjectWidgetView(project: Project.preview)
        .previewContext(WidgetPreviewContext(family: .systemSmall))
}
