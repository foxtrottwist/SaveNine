//
//  SessionNavigationStack.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/13/23.
//

import SwiftData
import SwiftUI

private enum SortBy: Identifiable, CaseIterable {
    case endDate
    case project
    
    var id: Self { self }
}

extension SortBy {
    var description: LocalizedStringResource {
        switch self {
        case .endDate:
            "End Date"
        case .project:
            "Project Name"
        }
    }
}

struct SessionNavigationStack: View {
    @Environment(\.modelContext) private var modelContext
    @State private var fetchDescriptor = FetchDescriptor<Session>(predicate: #Predicate { $0.endDate != nil }, sortBy: [SortDescriptor(\.endDate, order: .reverse)])
    @State private var selectedSortOption: SortBy = .endDate
    @State private var selectedSortOrder: SortOrder = .reverse
    @State private var selectedLabel: String = ""
    
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
                        Picker("Sort Option", selection: $selectedSortOption) {
                            ForEach(SortBy.allCases) { option in
                                Text(option.description).tag(option)
                            }
                        }
                        Picker("Sort Order", selection: $selectedSortOrder) {
                            Text("Ascending").tag(SortOrder.forward)
                            Text("Descending").tag(SortOrder.reverse)
                        }
                        
                    } label: {
                        Label("Sort By", systemImage: "arrow.up.arrow.down")
                    }
                    .onChange(of: selectedSortOption, sortBy)
                    .onChange(of: selectedSortOrder, sortBy)
                } label: {
                    Label("Sessions Menu", systemImage: "ellipsis.circle")
                }
            }
        }
    }
    
    private func sortBy() {
        switch selectedSortOption {
        case .endDate:
            fetchDescriptor.sortBy = [SortDescriptor(\.endDate, order: selectedSortOrder)]
        case .project:
            fetchDescriptor.sortBy = [SortDescriptor(\.project?.name, order: selectedSortOrder)]
        }
    }
    
    static let tag: String? = "Sessions"
}

#Preview {
    SessionNavigationStack()
}
