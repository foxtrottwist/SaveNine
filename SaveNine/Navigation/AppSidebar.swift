//
//  ProjectsSidebar.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/29/23.
//

import SwiftData
import SwiftUI

struct AppSidebar: View {
    @Bindable var navigation: AppNavigation
    @Environment (\.modelContext) private var modelContext
    @Environment(\.prefersTabNavigation) private var prefersTabNavigation
    @Query(FetchDescriptor(sortBy: [SortDescriptor<Tag>(\.name, order: .forward)])) private var tags: [Tag]
    
    private var defaultFilters: [Filter] {
        if prefersTabNavigation {
            return [.open, .closed, .all]
        } else {
            return [.open, .closed, .all, .sessions]
        }
    }
    
    private var filters: [Filter] {
        tags.map {
            Filter(id: $0.id!, name: $0.name!, icon: "tag")
        }
    }
    
    var body: some View {
        List(selection: $navigation.filter) {
            ForEach(defaultFilters) { filter in
                NavigationLink(value: filter) {
                    Label(filter.name, systemImage: filter.icon)
                }
            }
            
            Section("Tags") {
                ForEach(filters) { filter in
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                    }
                }
                .onDelete(perform: deleteTags)
            }
        }
        .navigationTitle("Save Nine")
    }
    
    private func deleteTags(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(tags[index])
            }
        }
    }
}

#Preview {
    AppSidebar(navigation: AppNavigation())
        .modelContainer(for: [Project.self, Session.self, Tag.self], inMemory: true)
}
