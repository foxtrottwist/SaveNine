//
//  ProjectRowView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/26/22.
//

import SwiftUI

struct ProjectRowView: View {
    @ObservedObject var project: Project
    
    let uiImage: UIImage?
    
    init(project: Project) {
        self.project = project
        
        if let imageName = project.image {
            self.uiImage = getImage(named: imageName)
        } else {
            self.uiImage = nil
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(project.projectName)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(project.projectDetail)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                if let uiImage = uiImage, let image = Image(uiImage: uiImage) {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
            }
            
            HStack {
                Text("Tags")
                    .font(.footnote)
                    .foregroundColor(.clear)
            }
        }
    }
}

struct ProjectRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectRowView(project: Project.example)
    }
}
