//
//  ProjectNavigationStack.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/29/23.
//

import SwiftData
import SwiftUI

struct ProjectNavigationStack: View {
    let screen: Screen
    @Environment (\.modelContext) private var modelContext
    @State private var disabled = false
    @State private var navigator = Navigator.shared
    @State private var searchText = ""
    
    private var predicate: Predicate<Project>? {
        switch screen {
        case .open:
            #Predicate { $0.closed != nil && $0.closed == false }
        case .closed:
            #Predicate { $0.closed != nil && $0.closed == true }
        case .tag(let name, _):
            #Predicate { $0.tags!.contains {  $0.name! == name }  }
        default:
            nil
        }
    }
    
    
    var body: some View {
        NavigationStack(path: $navigator.path) {
            QueryView(FetchDescriptor(predicate: predicate, sortBy: [SortDescriptor<Project>(\.creationDate, order: .reverse)]), { projects in
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
                    if projects.isEmpty, searchText.isEmpty {
                        switch screen {
                        case .all, .open:
                            ContentUnavailableView("Please add a project to begin.", systemImage: "plus.square")
                        case .closed:
                            ContentUnavailableView("There are currently no closed projects.", systemImage: "archivebox")
                        case .tag(let name, _):
                            ContentUnavailableView("There are currently no Projects tagged with \(name).", systemImage: "tag")
                        default:
                           EmptyView()
                        }
                    }
                }
            })
            .listStyle(.inset)
            .navigationDestination(for: Project.self) { project in
                ProjectDetail(project: project)
            }
            .navigationTitle(screen.title)
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
    ProjectNavigationStack(screen: .open)
        .modelContainer(for: [Project.self, Session.self, Tag.self], inMemory: true)
}
