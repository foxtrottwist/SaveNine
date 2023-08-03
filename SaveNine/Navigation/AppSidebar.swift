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
    
    private var defaultLinks: [AppNavigationLink] {
        prefersTabNavigation ? [.open, .closed, .all] : [.open, .closed, .all, .sessions]
    }
    private var Links: [AppNavigationLink] {
        tags.map {
            AppNavigationLink(id: $0.id!, name: $0.name!, icon: "tag")
        }
    }
    
    var body: some View {
        List(selection: $navigation.filter) {
            ForEach(defaultLinks) { filter in
                NavigationLink(value: filter) {
                    Label(filter.name, systemImage: filter.icon)
                }
            }
            
            Section("Tags") {
                ForEach(Links) { link in
                    NavigationLink(value: link) {
                        Label(link.name, systemImage: link.icon)
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
