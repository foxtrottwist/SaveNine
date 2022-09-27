//
//  ProjectsView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import SwiftUI

struct ProjectsView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)]) var projects: FetchedResults<Project>
    
    @State private var selectedProject: Project?
    @State private var path: [Project] = []
    @State private var disabled = false
    
    var body: some View {
        NavigationSplitView {
            List(projects, selection: $selectedProject) { project in
                if project.projectName.isEmpty {
                    ProjectNameView(project: project)
                        .onAppear {
                            disabled = true
                        }
                        .onDisappear {
                            disabled = false
                        }
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
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        addProject()
                    } label: {
                        Image(systemName: "plus.circle")
                        Text("**Add Project**")
                    }
                    .disabled(disabled)
                }
            }
        } detail: {
            if let project = selectedProject {
                NavigationStack(path: $path) {
                    ProjectDetailView(project: project )
                }
                
            } else {
                Text("Please select a project from the menu to begin.")
                    .italic()
                    .foregroundColor(.secondary)
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

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectsView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
