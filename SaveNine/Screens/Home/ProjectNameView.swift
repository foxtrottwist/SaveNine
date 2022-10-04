//
//  ProjectNameView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/24/22.
//

import SwiftUI

struct ProjectNameView: View {
    let project: Project
    
    @EnvironmentObject var dataController: DataController
    
    @State private var name = ""
    @FocusState var focused: Bool
    
    var body: some View {
        TextField("Project name", text: $name)
            .focused($focused)
            .onAppear {
                focused = true
            }
            .onSubmit {
                if name.isEmpty {
                    dataController.delete(project)
                } else {
                    project.name = name
                }
                
                dataController.save()
            }
            .submitLabel(.done)
    }
}

struct ProjectNameView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectNameView(project: Project.example)
    }
}
