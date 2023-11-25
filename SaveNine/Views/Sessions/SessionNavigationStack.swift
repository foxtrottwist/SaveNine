//
//  SessionNavigationStack.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/13/23.
//

import SwiftData
import SwiftUI

struct SessionNavigationStack: View {
    @Environment(\.modelContext) private var modelContext
    @SceneStorage(StorageKey.sessionsSortOptions.rawValue) private var data: Data?
    @State private var fetchDescriptor = FetchDescriptor<Session>(predicate: #Predicate { $0.endDate != nil }, sortBy: [SortDescriptor(\.endDate, order: .reverse)])
    @State private var selectedLabel: String = ""
    @State private var sortValues = SortValues()
    
    var body: some View {
        NavigationStack {
            QueryView(fetchDescriptor) { sessions in
                if sessions.isEmpty {
                    ContentUnavailableView(
                        "No sessions have been completed or match the current filter.",
                        systemImage: "hourglass.bottomhalf.filled"
                    )
                } else {
                    List {
                        ForEach(sessions) { session in
                            VStack(alignment: .leading) {
                                Text(session.project?.displayName ?? "")
                                    .font(.headline)
                                
                                SessionRow(session: session)
                            }
                        }
                        .onDelete { offsets in
                            for offset in offsets {
                                let session = sessions[offset]
                                modelContext.delete(session)
                            }
                        }
                    }
                    .listStyle(.grouped)
                }
            }
            .navigationTitle("Sessions")
            .toolbar {
                Menu {
                    Menu {
                        Button {
                            selectedLabel.removeAll()
                        } label: {
                            Label("Clear Filter", systemImage: "xmark.circle")
                        }
                        
                        SessionLabelPicker(selectedLabel: $selectedLabel, disabled: true)
                    } label: {
                        Label("Filter By", systemImage: "line.3.horizontal.decrease.circle")
                    }
                    
                    Menu {
                        Picker("Sort Option", selection: $sortValues.sortOption) {
                            ForEach(SortOption.allCases) { option in
                                Text(option.description).tag(option)
                            }
                        }
                        Picker("Sort Order", selection: $sortValues.sortOrder) {
                            Text("Ascending").tag(SortOrder.forward)
                            Text("Descending").tag(SortOrder.reverse)
                        }
                        
                    } label: {
                        Label("Sort By", systemImage: "arrow.up.arrow.down")
                    }
                    .onChange(of: sortValues.sortOption, sortBy)
                    .onChange(of: sortValues.sortOrder, sortBy)
                } label: {
                    Label("Sessions Menu", systemImage: "ellipsis.circle")
                }
            }
        }
        .task {
            if let data {
                sortValues.data = data
            }
        }
    }
    
    private func sortBy() {
        switch sortValues.sortOption {
        case .endDate:
            fetchDescriptor.sortBy = [SortDescriptor(\.endDate, order: sortValues.sortOrder)]
        case .project:
            fetchDescriptor.sortBy = [SortDescriptor(\Session.projectName, order: sortValues.sortOrder), SortDescriptor(\.endDate, order: .reverse)]
        }
        
        data = sortValues.data
    }
    
    static let tag: String? = "Sessions"
}

#Preview {
    SessionNavigationStack()
}
