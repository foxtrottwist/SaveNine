//
//  ProjectsTabView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import Combine
import CoreData
import SwiftUI

struct ProjectsTabView: View {
    static let tag: String? = "Projects"
    
    let subject: PassthroughSubject<String?, Never>
    
    @StateObject private var sortController = SortController(for: "projectSort", defaultSort: SortOption.creationDate, sortAscending: false)
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject private var dataController: DataController
    
    @State private var disabled = false
    @State private var path: [Project] = []
    @State private var searchText = ""
    @State private var selectedTags: [Ptag] = []
    @State private var showClosedProjects = false
    @State private var showingProjectTags = false
    @State private var showingSettingsView = false
    
    var body: some View {
        NavigationStack(path: $path) {
            TagDrawerView(selection: $selectedTags, isPresented: $showingProjectTags)
            
            FetchRequestView(Project.fetchProjects(predicate: createPredicate(), sortDescriptors: sortProjects())) { projects in
                if projects.isEmpty {
                    NoContentView(message: showClosedProjects ? "There are currently no closed projects." : "Please add a project to begin.")
                        .padding()
                } else {
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
                    .onChange(of: sortController.sortAscending) { sortController.save() }
                    .onChange(of: sortController.sortOption) { sortController.save() }
                    .onOpenURL(perform: { url in
                        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
                        guard let host = components?.host else { return }
                        let projectID = UUID(uuidString: host)
                        let project = projects.map { $0 }.filter { $0.id == projectID }
                        
                        if path.last?.id != projectID {
                            path.append(contentsOf: project)
                        }
                    })
                    .onReceive(subject, perform: { tab in
                        if tab == Self.tag, !path.isEmpty {
                            path = []
                        }
                    })
                    .searchable(text: $searchText)
                }
            }
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
            .navigationDestination(for: Project.self) { project in
                ProjectDetailView(project: project)
            }
            .sheet(isPresented: $showingSettingsView) {
                SettingsView()
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addProject) {
                        Label("Add Project", systemImage: "plus.square")
                    }
                    .disabled(disabled)
                }
                
                ToolbarItem {
                    Button {
                        showingProjectTags.toggle()
                    } label: {
                        Label("Tags", systemImage: "tag")
                            .font(.callout)
                    }
                    .disabled(disabled)
                }
                
                ToolbarItem {
                    Menu {
                        Button {
                            showingSettingsView.toggle()
                        } label: {
                            Label("Settings", systemImage: "gear")
                        }
                        
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
        ProjectsTabView(subject: PassthroughSubject<String?, Never>())
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
