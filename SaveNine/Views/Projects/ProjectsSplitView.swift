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
    let subject: PassthroughSubject<String?, Never>
    @Environment(Navigation.self) private var navigation
    @State private var disabled = false
    @State private var path: [Project] = []
    @State private var showingSettingsView = false
    @State private var sortController = SortController(for: "projectSort", defaultSort: SortOption.creationDate, sortAscending: false)
    
    init(subject: PassthroughSubject<String?, Never> = .init()) {
        self.subject = subject
    }
    
    var body: some View {
        NavigationSplitView {
            AppSidebar(navigation: navigation)
                .navigationTitle("Save Nine")
        } detail: {
            if navigation.filter == .sessions {
                SessionNavigationStack()
            } else {
                ProjectNavigationStack(path: $path)
                    .onChange(of: sortController.sortAscending) { sortController.save() }
                    .onChange(of: sortController.sortOption) { sortController.save() }
                    .onReceive(subject, perform: { tab in
                        if tab == Self.tag, !path.isEmpty {
                            path = []
                        }
                    })
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
    
    static let tag: String? = "Projects"
}

struct ProjectsTabView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectsSplitView(subject: PassthroughSubject<String?, Never>())
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environment(Navigation())
            .environmentObject(dataController)
    }
}
