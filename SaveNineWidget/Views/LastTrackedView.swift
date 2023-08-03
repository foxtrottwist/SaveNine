//
//  LastTrackedView.swift
//  SaveNineWidgetExtension
//
//  Created by Lawrence Horne on 1/16/23.
//

import SwiftUI
import WidgetKit

struct LastTrackedView: View {
    let project: Project
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(Color(red: 0.671, green: 0.949, blue: 0.604, opacity: 1.000).gradient)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(project.displayName)
                        .font(.callout)
                        .lineLimit(2)
                        .padding(1)
                    
                    Text(project.timeTracked)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("last tracked:")
                        .font(.caption)
                        .italic()
                    
                    Text(project.modificationDate!.relativeDescription())
                        .font(.subheadline)
                }
                .fontWeight(.medium)
                .foregroundColor(.black.opacity(0.6))
                .padding()
                
                Spacer()
            }
        }
        .widgetURL(createProjectUrl(id: project.id!))
    }
}

#Preview {
    LastTrackedView(project: Project.preview)
        .previewContext(WidgetPreviewContext(family: .systemSmall))
}
