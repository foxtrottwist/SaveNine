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
    @State private var sortController = SortController(for: "sessionSort", defaultSort: SortOption.startDate, sortAscending: false)
    @State private var selectedLabel: String = ""
    
    var body: some View {
        NavigationStack {
            QueryView(
                FetchDescriptor<Session>(
                    predicate: #Predicate { $0.endDate != nil }, 
                    sortBy: [SortDescriptor(\.endDate, order: .reverse)]
                )
            ) { sessions in
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
                    .onChange(of: sortController.sortAscending) { sortController.save() }
                    .onChange(of: sortController.sortOption) { sortController.save() }
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
                    
                    SortOptionsView(
                        sortOptions: [.project, .startDate],
                        selectedSortOption: $sortController.sortOption,
                        selectedSortOrder: $sortController.sortAscending
                    )
                } label: {
                    Label("Sessions Menu", systemImage: "ellipsis.circle")
                }
            }
        }
    }
    
    static let tag: String? = "Sessions"
}

#Preview {
    SessionNavigationStack()
}
