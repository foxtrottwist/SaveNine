//
//  ProjectsSidebar.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/29/23.
//

import SwiftData
import SwiftUI

struct AppSidebar: View {
    @Binding var selection: Screen?
    @Environment (\.modelContext) private var modelContext
    @Environment (\.prefersTabNavigation) private var prefersTabNavigation
    @State private var showingSettings = false
    @Query(FetchDescriptor(sortBy: [SortDescriptor<Tag>(\.name, order: .forward)])) private var tags: [Tag]
    
    var body: some View {
        List(selection: $selection) {
            ForEach(prefersTabNavigation ? Screen.prefersTabNavigationCases : Screen.allCases) { screen in
                NavigationLink(value: screen) {
                    screen.label
                }
            }
            
            Section("Tags") {
                ForEach(tags) { tag in
                    NavigationLink(value: Screen.tag(name: tag.displayName, id: tag.id!)) {
                        Label(tag.displayName, systemImage: "tag")
                    }
                }
                .onDelete(perform: deleteTags)
            }
        }
        .navigationTitle("Save Nine")
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .toolbar {
            Button {
                showingSettings.toggle()
            } label: {
                Label("Settings", systemImage: "gear")
            }
        }
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
    AppSidebar(selection: .constant(nil))
        .modelContainer(Persistence.previewContainer)
}
