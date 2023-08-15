//
//  ProjectsSidebar.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/29/23.
//

import SwiftData
import SwiftUI

struct AppSidebar: View {
    @Bindable var navigator: Navigator
    @Environment (\.modelContext) private var modelContext
    @Environment (\.prefersTabNavigation) private var prefersTabNavigation
    @Query(FetchDescriptor(sortBy: [SortDescriptor<Tag>(\.name, order: .forward)])) private var tags: [Tag]
    
    private var defaultLinks: [NavigatorLink] {
        prefersTabNavigation ? [.open, .closed, .all] : [.open, .closed, .all, .sessions]
    }
    
    private var links: [NavigatorLink] { tags.map { .init(from: $0) } }
    
    var body: some View {
        List(selection: $navigator.selection) {
            ForEach(defaultLinks) { link in
                NavigationLink(value: link) {
                    Label(link.name, systemImage: link.icon)
                }
            }
            
            Section("Tags") {
                ForEach(links) { link in
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
    AppSidebar(navigator: Navigator())
        .modelContainer(for: [Project.self, Session.self, Tag.self], inMemory: true)
}
