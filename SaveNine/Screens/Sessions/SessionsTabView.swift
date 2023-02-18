//
//  SessionsTabView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/13/23.
//

import SwiftUI

struct SessionsTabView: View {
    static let tag: String? = "Sessions"

    @SceneStorage("sessionSort") private var sessionSort: Data?
    @StateObject private var sortController = SortController(defaultSort: SortOption.startDate, sortAscending: false)
    
    @State private var selectedLabel: String = ""
    
    var body: some View {
        NavigationStack {
            FetchRequestView(
                Session.fetchSessions(predicate: createPredicate(), sortDescriptors: sortSessions())
            ) { sessions in
                List(sessions) { session in
                    VStack(alignment: .leading) {
                        Text(session.project?.projectName ?? "")
                            .font(.headline)
                        
                        SessionRowView(session: session)
                    }
                    
                }
                .listStyle(.grouped)
                .navigationTitle("Sessions")
                .toolbar {
                    Menu {
                        Menu {
                            Button {
                                selectedLabel.removeAll()
                            } label: {
                                Label("Clear Filter", systemImage: "xmark.circle")
                            }
                            
                            SessionLabelPickerView(selectedLabel: $selectedLabel, disableAddLabel: true)
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
        .task {
            if let sessionSort {
                sortController.jsonData = sessionSort
            }

            for await _ in sortController.objectWillChangeSequence {
                sessionSort = sortController.jsonData
            }
        }
    }
    
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
        SessionsTabView()
    }
}
