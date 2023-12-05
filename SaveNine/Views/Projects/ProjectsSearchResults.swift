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
    
    private var searchResult: [Project] {
        if searchText.isEmpty {
            projects
        } else {
            projects.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    init(projects: [Project], searchText: String, @ViewBuilder _ content: @escaping (Project) -> Content) {
        self.projects =  projects
        self.searchText = searchText
        self.content = content
    }
    
    var body: some View {
        List {
            ForEach(searchResult, content: content)
        }
        .overlay {
            if searchResult.isEmpty, !searchText.isEmpty {
                ContentUnavailableView.search
            }
        }
    }
}

#Preview {
    ProjectsSearchResults(projects: [Project.preview], searchText: "", { _ in EmptyView() })
        .modelContainer(for: [Project.self, Session.self, Tag.self], inMemory: true)
}
