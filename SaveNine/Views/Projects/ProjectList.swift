//
//  ProjectList.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/29/23.
//

import SwiftUI

struct ProjectList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\Project.creationDate, order: .forward)]) private var projects: FetchedResults<Project>
    @State private var disabled = false
    @State private var searchText = ""
    
    var body: some View {
        List {
            ProjectsSearchResults(projects: projects, searchText: searchText) { project in
                if project.displayName.isEmpty {
                    ProjectName(project: project)
                        .onAppear { disabled = true }
                        .onDisappear { disabled = false }
                } else {
                    VStack {
                        NavigationLink(value: project) {
                            ProjectRow(project: project)
                        }
                    }
                    .disabled(disabled)
                }
            }
        }
        .listStyle(.inset)
        .searchable(text: $searchText, placement: .navigationBarDrawer)
        .toolbar {
            ToolbarItem {
                Button(action: addProject) {
                    Label("Add Project", systemImage: "plus.square")
                }
                .disabled(disabled)
            }
        }
    }
    
    func addProject() {
        let newProject = Project(context: managedObjectContext)
        newProject.id = UUID()
        newProject.closed = false
        newProject.creationDate = Date()
    }
}

#Preview {
    ProjectList()
}
