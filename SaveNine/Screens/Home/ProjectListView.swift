//
//  ProjectListView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/27/22.
//

import CoreData
import SwiftUI

struct ProjectListView: View {
    @FetchRequest var projects: FetchedResults<Project>
    
    @State private var disabled = false
    
    init(_ fetchRequest: NSFetchRequest<Project>) {
        _projects  = FetchRequest<Project>(fetchRequest: fetchRequest)
        }
    
    var body: some View {
        List(projects) { project in
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
        .listStyle(.inset)
        .navigationTitle("Projects")
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView(Project.fetchProjects(predicate: nil, sortDescriptors: nil))
    }
}
