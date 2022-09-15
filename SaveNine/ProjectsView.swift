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
    
    var body: some View {
        NavigationSplitView {
            List(projects, selection: $selectedProject) { project in
                NavigationLink(project.projectName, value: project)
            }
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        addProject()
                    } label: {
                        Image(systemName: "plus.circle")
                        Text("**Add Project**")
                    }
                }
            }
        } detail: {
            NavigationStack(path: $path) {
                ProjectDetailView(project: selectedProject )
            }
        }
    }
    
    func addProject() {
        let newProject = Project(context: managedObjectContext)
        newProject.id = UUID()
        newProject.closed = false
        newProject.creationDate = Date()
        
        let supplies = ItemList(context: managedObjectContext)
        supplies.name = "Supplies"
        supplies.creationDate = Date()
        supplies.project = newProject
        
        let todos = ItemList(context: managedObjectContext)
        todos.name = "Todos"
        todos.creationDate = Date()
        todos.project = newProject
        
        dataController.save()
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
