//
//  ProjectNavigationStack.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/29/23.
//

import SwiftData
import SwiftUI

struct ProjectNavigationStack: View {
    @Binding var path: [Project]
    @Environment(AppNavigation.self) private var navigation
    @Environment (\.modelContext) private var modelContext
    @State private var disabled = false
    @State private var searchText = ""
    @Query(sort: \Project.creationDate, order: .reverse) private var projects: [Project]
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
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
            }
            .listStyle(.inset)
            .navigationDestination(for: Project.self) { project in
                ProjectDetail(project: project)
            }
            .navigationTitle(navigation.filter?.name ?? "")
            .onOpenURL(perform: { url in
                let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
                guard let host = components?.host else { return }
                let projectID = UUID(uuidString: host)
                let project = projects.map { $0 }.filter { $0.id == projectID }
                
                if path.last?.id != projectID {
                    path.append(contentsOf: project)
                }
            })
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

#Preview {
    ProjectNavigationStack(path: .constant([]))
        .modelContainer(for: [Project.self, Session.self, Tag.self], inMemory: true)
}
