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
    @State private var selectedProject: Project?
    @State private var selectedTags: [Ptag] = []
    @State private var showClosedProjects = false
    @State private var showingProjectTags = false
    @State private var sortAscending = false
    
    var body: some View {
        NavigationSplitView {
            if showingProjectTags {
                tagControls
                ProjectTagsView(selection: $selectedTags)
            }
            
            ProjectListView(Project.fetchProjects(predicate: createPredicate(), sortDescriptors: sortProjects()), selection: $selectedProject)
                .searchable(text: $searchText)
                .toolbar {
                    menuToolbarItem
                    addProjectBottomToolbarItem
                }
        } detail: {
            if let project = selectedProject {
                NavigationStack(path: $path) {
                    ProjectDetailView(project: project )
                }
            } else {
                NoContentView(message: "Please select a project from the menu to begin.")
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
            }
            .foregroundColor(Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000))
        }
        .padding([.horizontal, .top])
    }
    
    var menuToolbarItem: some ToolbarContent {
        ToolbarItem {
            Menu {
                Picker("Project Status", selection: $showClosedProjects) {
                    Label("Open", systemImage: "tray.full").tag(false)
                    Label("Archived", systemImage: "archivebox").tag(true)
                }
                
                Button {
                    showingProjectTags.toggle()
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
