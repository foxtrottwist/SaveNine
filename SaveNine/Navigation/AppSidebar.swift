//
//  ProjectsSidebar.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/29/23.
//

import SwiftUI

struct AppSidebar: View {
    @Bindable var navigation: AppNavigation
    @Environment(\.prefersTabNavigation) private var prefersTabNavigation
    @EnvironmentObject private var dataController: DataController
    @FetchRequest(sortDescriptors: [SortDescriptor(\Tag.name, order: .forward)]) private var tags
    
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
                dataController.delete(tags[index])
            }
        }
    }
}

#Preview {
    AppSidebar(navigation: AppNavigation())
}
