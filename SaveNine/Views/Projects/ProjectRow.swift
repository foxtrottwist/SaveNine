//
//  ProjectRow.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/26/22.
//

import SwiftUI

struct ProjectRow: View {
    var project: Project
    private var tracking: Bool { project.tracking ?? false }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                if tracking {
                    Image(systemName: "stopwatch")
                        .symbolEffect(.pulse, isActive: tracking)
                        .foregroundColor(.accentColor)
                }
                
                VStack(alignment: .leading) {
                    Text(project.name)
                        .font(.headline)
                        .lineLimit(2, reservesSpace: true)
                    
                    Text(project.detail)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(3, reservesSpace: true)
                }
                
                Spacer()
                
                if let data = project.image, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .projectImage(width: 100, height: 100, cornerRadius: 10)
                } else {
                    Image(systemName: "photo")
                        .projectImage(width: 100, height: 100, cornerRadius: 10)
                        .foregroundColor(.clear)
                }
            }
            
            HStack {
                Image(systemName: "tag")
                    .font(.caption2)
                    .foregroundColor(project.displayTags.isEmpty ? .clear : .accent)
                
                Text(project.displayTags)
                    .font(.footnote)
                    .foregroundColor(.accent)
            }
            .padding(.top, 0.25)
        }
    }
}

#Preview {
    ProjectRow(project: Project.preview)
}
