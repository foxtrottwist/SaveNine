//
//  ProjectsView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import SwiftUI

struct ProjectsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataController: DataController
    
    @FetchRequest(fetchRequest: Ptag.fetchAllTags) var ptags: FetchedResults<Ptag>
    
    @State private var searchText = ""
    @State private var selectedProject: Project?
    @State private var showClosedProjects = false
    @State private var showingProjectFilters = false
    @State private var sortAscending = false
    @State private var path: [Project] = []
    @State private var disabled = false
    
    var body: some View {
        NavigationSplitView {
            ProjectListView(selectedProject: $selectedProject, sortDescriptors: sortProjects(), predicate: searchProjects())
                .listStyle(.inset)
                .navigationTitle("Projects")
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem {
                        Menu {
                            Picker("Project Status", selection: $showClosedProjects) {
                                Label("Open", systemImage: "tray.full").tag(false)
                                Label("Archived", systemImage: "archivebox").tag(true)
                            }
                            
                            Button {
                                showingProjectFilters.toggle()
                            } label: {
                                Label("Tags", systemImage: "tag")
                            }
                            
                            Picker("Sort By Creation Date", selection: $sortAscending) {
                                Text("Newest First").tag(false)
                                Text("Oldest First").tag(true)
                            }
                        } label: {
                            Label("Menu", systemImage: "ellipsis.circle")
                        }
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            addProject()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                            Text("**Add Project**")
                        }
                        .disabled(disabled)
                    }
                }
                .sheet(isPresented: $showingProjectFilters) {
                    ProjectTagsView()
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
    
    func searchProjects() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(format: "closed = %d", showClosedProjects)
        } else {
            return NSPredicate(format: "closed = %d AND %K CONTAINS[c] %@", showClosedProjects, "name", searchText)
        }
    }
    
    func sortProjects() -> [NSSortDescriptor] {
        return [NSSortDescriptor(keyPath: \Project.creationDate, ascending: sortAscending)]
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
