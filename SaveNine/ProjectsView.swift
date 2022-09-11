//
//  ProjectsView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import SwiftUI

struct ProjectsView: View {
    // Currently only needed for temporary "Add Data" button
    @EnvironmentObject var dataController: DataController
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)]) var projects: FetchedResults<Project>
    
    @State private var selectedProject: Project?
    
    var body: some View {
        NavigationSplitView {
            List(projects, selection: $selectedProject) {
                Text($0.projectName).tag($0)
            }
            .navigationTitle("Projects")
            .toolbar {
                // Temporary button to add data during development
                Button("Add Data") {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }
            }
        } detail: {
            if selectedProject == nil {
                Text("Please select a project from the menu to begin.")
                    .italic()
                    .foregroundColor(.secondary)
            } else {
                ProjectDetailView(project: selectedProject! )
            }
        }
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
