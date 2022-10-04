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
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                
                Spacer()
                
                if let uiImage = uiImage, let image = Image(uiImage: uiImage) {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
                        .frame(width: 50, height: 50)
                }
            }
            
                HStack {
                    Image(systemName: "tag")
                        .font(.caption2)
                        .foregroundColor(project.protectTagsString.isEmpty ? .clear : .secondary)
                    
                    
                    Text(project.protectTagsString)
                        .font(.footnote)
                        .foregroundColor(Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000))
                }
                .padding(.top, 0.25)
                

        }
    }
}

struct ProjectRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectRowView(project: Project.example)
    }
}
