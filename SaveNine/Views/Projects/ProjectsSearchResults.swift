//
//  ProjectsSearchResults.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/29/23.
//

import SwiftUI

struct ProjectsSearchResults<Content: View>: View {
    let projects: [Project]
    let searchText: String
    let content: (Project) -> Content
    @Environment (\.modelContext) private var modelContext
    
    init(projects: [Project], searchText: String, @ViewBuilder _ content: @escaping (Project) -> Content) {
        self.projects =  projects
        self.searchText = searchText
        self.content = content
    }
    
    var body: some View {
        if searchText.isEmpty {
            ForEach(projects, content: content).onDelete(perform: deleteProjects)
        } else {
            ForEach(
                projects.filter {
                    if let name = $0.name {
                        name.lowercased().contains(searchText.lowercased())
                    } else {
                        false
                    }
                },
                content: content
            )
            .onDelete(perform: deleteProjects)
        }
    }
    
    private func deleteProjects(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(projects[index])
            }
        }
    }
}

#Preview {
    ProjectsSearchResults(projects: [Project.preview], searchText: "", { _ in EmptyView() })
        .modelContainer(for: [Project.self, Session.self, Tag.self], inMemory: true)
}
