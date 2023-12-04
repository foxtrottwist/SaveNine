//
//  TagNavigationStack.swift
//  SaveNine
//
//  Created by Lawrence Horne on 12/4/23.
//

import SwiftData
import SwiftUI

struct TagNavigationStack: View {
    let screen: Screen
    @State private var fetchDescriptor: FetchDescriptor<Tag>
    @State private var searchText = ""
    
    init(screen: Screen) {
        self.screen = screen
        
        let fetchDescriptor = switch screen {
        case .tag(_, let id):
            FetchDescriptor<Tag>(predicate: #Predicate { $0.id == id }, sortBy: [])
        default:
            FetchDescriptor<Tag>()
        }
        
        _fetchDescriptor = State(wrappedValue: fetchDescriptor)
    }
    
    var body: some View {
        NavigationStack {
            QueryView(fetchDescriptor) { tags in
                if let projects = tags.first?.projects?.sorted(using: KeyPathComparator(\.name)) {
                    ProjectsSearchResults(projects: projects, searchText: searchText) { project in
                        ProjectNavigationLink(project: project)
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle(screen.title)
            .searchable(text: $searchText, placement: .navigationBarDrawer)
            .navigationDestination(for: Project.self) { project in
                ProjectDetail(project: project)
            }
            .overlay {
                GlobalTracker()
            }
        }
    }
}

#Preview {
    TagNavigationStack(screen: Screen.tag(name: "You're it!", id: UUID()))
}
