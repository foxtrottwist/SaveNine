//
//  ProjectsNavigationSplitView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import Combine
import CoreData
import SwiftUI

struct ProjectsSplitView: View {
    static let tag: String? = "Projects"
    let subject: PassthroughSubject<String?, Never>
    @State private var disabled = false
    @State private var path: [Project] = []
    @State private var projectNavigation = ProjectNavigation()
    @State private var showingSettingsView = false
    @State private var sortController = SortController(for: "projectSort", defaultSort: SortOption.creationDate, sortAscending: false)
    
    var body: some View {
        NavigationSplitView {
            ProjectsSidebar(projectNavigation: projectNavigation)
        } detail: {
            NavigationStack(path: $path) {
                ProjectList(path: $path)
                    .onChange(of: sortController.sortAscending) { sortController.save() }
                    .onChange(of: sortController.sortOption) { sortController.save() }
                    .onReceive(subject, perform: { tab in
                        if tab == Self.tag, !path.isEmpty {
                            path = []
                        }
                    })
                    .navigationTitle(projectNavigation.filter?.name ?? "")
                    .navigationDestination(for: Project.self) { project in
                        ProjectDetail(project: project)
                    }
                    .sheet(isPresented: $showingSettingsView) {
                        SettingsView()
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing, content: {
                            Menu {
                                Button {
                                    showingSettingsView.toggle()
                                } label: {
                                    Label("Settings", systemImage: "gear")
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
                        })
                    }
            }
        }
    }
}

struct ProjectsTabView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectsSplitView(subject: PassthroughSubject<String?, Never>())
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
