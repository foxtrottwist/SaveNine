//
//  ProjectNavigationStack.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/29/23.
//

import SwiftData
import SwiftUI

private enum Descriptor {
    case project(FetchDescriptor<Project>)
    case tag(FetchDescriptor<Tag>)
}

struct ProjectNavigationStack: View {
    let screen: Screen
    private let fetchDescriptor: Descriptor
    @Environment(\.modelContext) private var modelContext
    @Environment(\.prefersTabNavigation) private var prefersTabNavigation
    @State private var disabled = false
    @State private var navigator = Navigator.shared
    @State private var searchText = ""
    
    init(screen: Screen) {
        self.screen = screen
        
        fetchDescriptor = switch screen {
        case .closed:
                .project(FetchDescriptor<Project>(
                    predicate: #Predicate<Project> { $0.closed == true },
                    sortBy: [SortDescriptor(\.creationDate, order: .reverse)]
                ))
        case .open:
                .project(FetchDescriptor<Project>(
                    predicate: #Predicate<Project> { $0.closed == false },
                    sortBy: [SortDescriptor(\.creationDate, order: .reverse)]
                ))
        case .tag(_, let id):
                .tag(FetchDescriptor<Tag>(predicate: #Predicate { $0.id == id }, sortBy: []))
        default:
                .project(FetchDescriptor<Project>(sortBy: [SortDescriptor(\.creationDate, order: .reverse)]))
        }
    }
    
    var body: some View {
        NavigationStack(path: $navigator.path) {
            Group {
                switch fetchDescriptor {
                case .project(let fetchDescriptor):
                    QueryView(fetchDescriptor) { projects in
                        projectsList(projects)
                    }
                case .tag(let fetchDescriptor):
                    QueryView(fetchDescriptor) { tags in
                        if let projects = tags.first?.projects {
                            projectsList(projects)
                        }
                    }
                }
            }
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
    
    private func projectsList(_ projects: [Project]) -> some View {
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
            
            if let project /*, navigator.path.last?.id != projectID*/ {
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
                    ContentUnavailableView("There are currently no Projects tagged with \"\(name)\".", systemImage: "tag")
                default:
                    EmptyView()
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
