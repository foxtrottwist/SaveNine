//
//  ProjectNavigationStack.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/29/23.
//

import SwiftData
import SwiftUI

struct ProjectNavigationStack: View {
    @Bindable var navigator: Navigator
    @Environment (\.modelContext) private var modelContext
    @State private var disabled = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack(path: $navigator.path) {
            QueryView(FetchDescriptor(sortBy: [SortDescriptor<Project>(\.creationDate, order: .reverse)]), { projects in
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
                .onOpenURL(perform: { url in
                    let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
                    guard let host = components?.host else { return }
                    let projectID = UUID(uuidString: host)
                    let project = projects.first { $0.id == projectID }
                    
                    if let project, navigator.path.last?.id != projectID {
                        navigator.path.append(project)
                    }
                })
                .overlay {
                    if let filter = navigator.link , projects.isEmpty, searchText.isEmpty {
                        switch filter {
                        case .all, .open:
                            ContentUnavailableView("Please add a project to begin.", systemImage: "plus.square")
                        case .closed:
                            ContentUnavailableView("There are currently no closed projects.", systemImage: "archivebox")
                        default:
                            ContentUnavailableView("There are currently no Projects tagged with \(filter.name).", systemImage: "tag")
                        }
                    }
                }
            })
            .listStyle(.inset)
            .navigationDestination(for: Project.self) { project in
                ProjectDetail(project: project)
            }
            .navigationTitle(navigator.link?.name ?? "")
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
    }
    
    func addProject() {
        modelContext.insert(Project(name: ""))
    }
}

//#Preview {
//    ProjectNavigationStack(path: .constant([]))
//        .modelContainer(for: [Project.self, Session.self, Tag.self], inMemory: true)
//}
