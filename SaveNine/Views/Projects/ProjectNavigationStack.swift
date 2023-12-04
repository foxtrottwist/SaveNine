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
    @Environment(\.modelContext) private var modelContext
    @Environment(\.prefersTabNavigation) private var prefersTabNavigation
    @State private var disabled = false
    @State private var fetchDescriptor: FetchDescriptor<Project>
    @State private var navigator = Navigator.shared
    @State private var searchText = ""
    
    init(screen: Screen) {
        self.screen = screen
        
        let fetchDescriptor: FetchDescriptor<Project> = switch screen {
        case .open:
            FetchDescriptor<Project>(
                predicate: Project.predicate(closed: false),
                sortBy: [SortDescriptor(\.creationDate, order: .reverse)]
            )
        case .closed:
            FetchDescriptor<Project>(
                predicate: Project.predicate(closed: true),
                sortBy: [SortDescriptor(\.creationDate, order: .reverse)]
            )
        default:
            FetchDescriptor<Project>(sortBy: [SortDescriptor(\.creationDate, order: .reverse)])
        }
        
        _fetchDescriptor = State(wrappedValue: fetchDescriptor)
    }
    
    var body: some View {
        NavigationStack(path: $navigator.path) {
            QueryView(fetchDescriptor) { projects in
                List {
                    ForEach(projects) { project in
                        if project.displayName.isEmpty {
                            ProjectName(project: project)
                                .onAppear { disabled = true }
                                .onDisappear { disabled = false }
                        } else {
                            ProjectNavigationLink(project: project)
                                .disabled(disabled)
                        }
                    }
                }
                .listStyle(.inset)
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
                    GlobalTracker()
                    
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
                    
                    if projects.isEmpty, !searchText.isEmpty {
                        ContentUnavailableView.search
                    }
                }
            }
            .onChange(of: searchText, search)
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
    
    private func addProject() {
        modelContext.insert(Project(name: ""))
    }
    
    private func search() {
        fetchDescriptor = switch screen {
        case .closed:
            FetchDescriptor<Project>(
                predicate: Project.predicate(searchText: searchText, closed: true),
                sortBy: [SortDescriptor(\.creationDate, order: .reverse)]
            )
        case .open:
            FetchDescriptor<Project>(
                predicate: Project.predicate(searchText: searchText, closed: false),
                sortBy: [SortDescriptor(\.creationDate, order: .reverse)]
            )
        default:
            FetchDescriptor<Project>(sortBy: [SortDescriptor(\.creationDate, order: .reverse)])
        }
    }
}

#Preview {
    ProjectNavigationStack(screen: .open)
        .modelContainer(for: [Project.self, Session.self, Tag.self], inMemory: true)
}
