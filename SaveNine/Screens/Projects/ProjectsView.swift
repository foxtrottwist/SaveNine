//
//  ProjectsView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import CoreData
import SwiftUI

struct ProjectsView: View {
    static let tag: String? = "Projects"
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataController: DataController
    
    @State private var disabled = false
    @State private var path: [Project] = []
    @State private var projectSort = ProjectSort.creationDate
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
                .onOpenURL(perform: { url in
                    let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
                    guard let host = components?.host else { return }
                    let project = projects.map { $0 }.filter { $0.id == UUID(uuidString: host) }
                    
                    if path.isEmpty || path.last?.id != UUID(uuidString: host) {
                        path.append(contentsOf: project)
                    }
                })
            }
            .listStyle(.inset)
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
            .navigationDestination(for: Project.self) { project in
                ProjectDetailView(project: project)
            }
            .searchable(text: $searchText)
            .toolbar {
                addProjectToolbarItem
                tagToggleToolbarItem
                menuToolbarItem
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
    
    var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem {
            Button(action: addProject) {
                Label("Add Project", systemImage: "plus.square")
            }
            .disabled(disabled)
        }
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
                    Label("Closed", systemImage: "archivebox").tag(true)
                }
                
                Menu {
                    Picker("Sort Items", selection: $projectSort) {
                        Text("Creation Date").tag(ProjectSort.creationDate)
                        Text("Title").tag(ProjectSort.name)
                    }
                    
                    Picker("Sort Items Options", selection: $sortAscending) {
                        if projectSort == .creationDate {
                            Text("Newest First").tag(false)
                            Text("Oldest First").tag(true)
                        } else if projectSort == .name {
                            Text("Ascending").tag(true)
                            Text("Descending").tag(false)
                        }
                    }
                } label: {
                    Label("Sort By", systemImage: "arrow.up.arrow.down")
                }
            } label: {
                Label("Menu", systemImage: "ellipsis.circle")
            }
            .disabled(disabled)
        }
    }
    
    func addProject() {
        withAnimation {
            selectedTags = []
            showingProjectTags = false
            showClosedProjects = false
        }
        
        let newProject = Project(context: managedObjectContext)
        newProject.id = UUID()
        newProject.closed = false
        newProject.creationDate = Date()
    }
    
    private func createPredicate() -> NSPredicate {
        return FetchPredicate.create(
            from: [
                (.closed, showClosedProjects),
                !searchText.isEmpty ? (.search, searchText) : nil,
            ] + selectedTags.map { (.tag, $0.ptagName) }
        )
    }
    
    enum ProjectSort {
        case creationDate, name
    }
    
    func sortProjects() -> [NSSortDescriptor] {
        switch projectSort {
        case .creationDate:
            return [NSSortDescriptor(keyPath: \Project.creationDate, ascending: sortAscending)]
        case .name:
            return [NSSortDescriptor(keyPath: \Project.name, ascending: sortAscending)]
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
