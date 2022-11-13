//
//  ProjectsView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import CoreData
import SwiftUI

struct ProjectsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataController: DataController
    
    @State private var disabled = false
    @State private var path: [Project] = []
    @State private var searchText = ""
    @State private var selectedTags: [Ptag] = []
    @State private var showClosedProjects = false
    @State private var showingProjectTags = false
    @State private var sortAscending = false
    
    var body: some View {
        NavigationStack(path: $path) {
            if showingProjectTags {
                tagControls
                ProjectTagsView(selection: $selectedTags)
            }
            
            FetchRequestView(Project.fetchProjects(predicate: createPredicate(), sortDescriptors: sortProjects())) { projects in
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
            }
            .listStyle(.inset)
            .navigationTitle("Projects")
            .navigationDestination(for: Project.self) { project in
                ProjectDetailView(project: project)
            }
            .searchable(text: $searchText)
            .toolbar {
                tagToggleToolbarItem
                menuToolbarItem
                addProjectBottomToolbarItem
            }
        }
    }
    
    var tagControls: some View {
        HStack {
            Button {
                showingProjectTags.toggle()
            } label: {
                Image(systemName: "xmark.circle")
                    .foregroundColor(Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000))
            }
            
            Spacer()
            
            Button {
                withAnimation {
                    selectedTags = []
                }
            } label: {
                Image(systemName: "tag.slash")
                    .font(.callout)
                
                Text("Clear Tags \(selectedTags.count)")
                    .font(.callout)
                    .monospacedDigit()
            }
            .foregroundColor(Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000))
        }
        .padding([.horizontal, .top])
    }
    
    var tagToggleToolbarItem: some ToolbarContent {
        ToolbarItem {
            Button {
                showingProjectTags.toggle()
            } label: {
                Label("Tags", systemImage: "tag")
                    .font(.callout)
            }
            .disabled(disabled)
        }
    }
    
    var menuToolbarItem: some ToolbarContent {
        ToolbarItem {
            Menu {
                Picker("Project Status", selection: $showClosedProjects) {
                    Label("Open", systemImage: "tray.full").tag(false)
                    Label("Archived", systemImage: "archivebox").tag(true)
                }
                
                Picker("Sort By Creation Date", selection: $sortAscending) {
                    Text("Newest First").tag(false)
                    Text("Oldest First").tag(true)
                }
            } label: {
                Label("Menu", systemImage: "ellipsis.circle")
            }
            .disabled(disabled)
        }
    }
    
    var addProjectBottomToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            Button(action: addProject) {
                Image(systemName: "plus.circle.fill")
                Text("Add Project")
                    .bold()
            }
            .disabled(disabled)
        }
    }
    
    func addProject() {
        withAnimation {
            selectedTags = []
            showingProjectTags = false
        }
        
        let newProject = Project(context: managedObjectContext)
        newProject.id = UUID()
        newProject.closed = false
        newProject.creationDate = Date()
    }
    
    func createPredicate() -> NSPredicate {
        let closedPredicate = NSPredicate(format: "closed = %d", showClosedProjects)
        
        if selectedTags.isEmpty && searchText.isEmpty {
            return closedPredicate
        }
        
        let searchPredicate = NSPredicate(format: "%K CONTAINS[c] %@", "name", searchText)
        
        if selectedTags.isEmpty {
            return NSCompoundPredicate(andPredicateWithSubpredicates: [closedPredicate, searchPredicate])
        }
        
        let tagPredicate = selectedTags.map { NSPredicate(format: "%@ IN tags.name", $0.ptagName) }
        
        if searchText.isEmpty {
            return NSCompoundPredicate(andPredicateWithSubpredicates: [closedPredicate] + tagPredicate)
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: [closedPredicate, searchPredicate] + tagPredicate)
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
