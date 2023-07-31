//
//  SessionsNavigationStack.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/13/23.
//

import SwiftUI

struct SessionsNavigationStack: View {
    @State private var sortController = SortController(for: "sessionSort", defaultSort: SortOption.startDate, sortAscending: false)
    @State private var selectedLabel: String = ""
    
    var body: some View {
        NavigationStack {
            FetchRequestView(
                Session.fetchSessions(predicate: createPredicate(), sortDescriptors: sortSessions())
            ) { sessions in
                if sessions.isEmpty {
                    NoContentView(message: "No sessions have been completed or match the current filter.")
                        .padding()
                } else {
                    List(sessions) { session in
                        VStack(alignment: .leading) {
                            Text(session.project?.displayName ?? "")
                                .font(.headline)
                            
                            SessionRow(session: session)
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
                        
                        SessionLabelPicker(selectedLabel: $selectedLabel, disableAddLabel: true)
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
    
    private func createPredicate() -> NSPredicate {
        return FetchPredicate.create(from: [!selectedLabel.isEmpty ? (.label, selectedLabel) : nil])
    }
    
    private func sortSessions() -> [NSSortDescriptor] {
        switch sortController.sortOption {
        case .project:
            return [NSSortDescriptor(keyPath: \Session.project, ascending: sortController.sortAscending)]
        case .startDate:
            return [NSSortDescriptor(keyPath: \Session.startDate, ascending: sortController.sortAscending)]
        default:
            return []
        }
    }
}

struct SessionsTabView_Previews: PreviewProvider {
    static var previews: some View {
        SessionsNavigationStack()
            .environment(SessionLabelController())
    }
}
