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
    @FocusState var focused: Bool
    @State private var name = ""
    
    var body: some View {
        TextField("Project name", text: $name)
            .focused($focused)
            .onAppear {
                focused = true
            }
            .onSubmit(submitProjectName)
            .submitLabel(.done)
    }
    
    func submitProjectName() {
        withAnimation {
            if name.isEmpty {
                // If a user initials adding a project but fails to give
                // the project a name and submits, the project will be
                // removed from the Projects view.
                dataController.delete(project)
            } else {
                project.name = name
            }
            
            dataController.save()
        }
    }
}

struct ProjectNameView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectNameView(project: Project.example)
    }
}
