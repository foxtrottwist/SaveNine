//
//  ProjectRow.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/26/22.
//

import SwiftUI

struct ProjectRow: View {
    var project: Project
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(project.displayName)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(project.projectDetail)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                
                Spacer()
                
                if let data = project.image, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .projectImage(width: 100, height: 100, cornerRadius: 10)
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
