//
//  ProjectListView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/27/22.
//

import SwiftUI

struct ProjectListView: View {
    @Binding var selectedProject: Project?
    
    @FetchRequest var projects: FetchedResults<Project>
    
    @State private var disabled = false
    
    init(selectedProject: Binding<Project?>, sortDescriptors: [NSSortDescriptor], predicate: NSPredicate) {
        _selectedProject = selectedProject
        _projects  = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: sortDescriptors, predicate: predicate)
        }
    
    var body: some View {
        List(projects, selection: $selectedProject) { project in
            if project.projectName.isEmpty {
                ProjectNameView(project: project)
                    .onAppear { disabled = true }
                    .onDisappear { disabled = false }
            } else {
                VStack {
                    NavigationLink(value: project) {
                        ProjectRowView(project: project)
                    }
                }
                .disabled(disabled)
            }
        }
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView(selectedProject: .constant(Project.example), sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)], predicate: NSPredicate(format: "closed = %d", false))
    }
}
