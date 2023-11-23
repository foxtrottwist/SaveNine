//
//  ProjectName.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/24/22.
//

import SwiftUI

struct ProjectName: View {
    let project: Project
    @Environment (\.modelContext) private var modelContext
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
    
    private func submitProjectName() {
        withAnimation {
            if name.isEmpty {
                // If a user starts to add a project but fails to give
                // the project a name and submits, the project will be
                // removed from the Projects view.
                modelContext.delete(project)
            } else {
                project.name = name
            }
        }
    }
}

#Preview {
    ProjectName(project: Project.preview)
}
