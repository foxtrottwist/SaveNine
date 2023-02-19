//
//  ProjectsTabView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import CoreData
import SwiftUI

struct ProjectsTabView: View {
    static let tag: String? = "Projects"
    
    @StateObject private var sortController = SortController(for: "projectSort", defaultSort: SortOption.creationDate, sortAscending: false)
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataController: DataController
    
    @State private var disabled = false
    @State private var path: [Project] = []
    @State private var searchText = ""
    @State private var selectedTags: [Ptag] = []
    @State private var showClosedProjects = false
    @State private var showingProjectTags = false
    
    var body: some View {
        NavigationStack(path: $path) {
            TagDrawerView(selection: $selectedTags, isPresented: $showingProjectTags)
            
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
                .onChange(of: sortController.sortAscending, perform: { _ in sortController.save() })
                .onChange(of: sortController.sortOption, perform: { _ in sortController.save() })
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
                
                SortOptionsView(
                    sortOptions: [SortOption.creationDate, SortOption.name],
                    selectedSortOption: $sortController.sortOption,
                    selectedSortOrder: $sortController.sortAscending
                )
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
    
    func sortProjects() -> [NSSortDescriptor] {
        switch sortController.sortOption {
        case .creationDate:
            return [NSSortDescriptor(keyPath: \Project.creationDate, ascending: sortController.sortAscending)]
        case .name:
            return [NSSortDescriptor(keyPath: \Project.name, ascending: sortController.sortAscending)]
        default:
            return []
        }
    }
}

struct ProjectsTabView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectsTabView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
