//
//  SessionsTabView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/13/23.
//

import SwiftUI

struct SessionsTabView: View {
    static let tag: String? = "Sessions"

    @State private var selectedLabel: String = ""
    @State private var sessionSort = SessionSort.startDate
    @State private var sortAscending = false
    
    var body: some View {
        NavigationStack {
            FetchRequestView(
                Session.fetchSessions(predicate: createPredicate(), sortDescriptors: sortDescriptors())
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
                        
                        Menu {
                            Picker("Sort Options", selection: $sessionSort) {
                                Text("Project").tag(SessionSort.project)
                                Text("Start Date").tag(SessionSort.startDate)
                            }
                            Divider()
                            
                            Picker("Sort By Date", selection: $sortAscending) {
                                Text("Newest First").tag(false)
                                Text("Oldest First").tag(true)
                            }
                        } label: {
                            Label("Sort By", systemImage: "arrow.up.arrow.down")
                        }
                    } label: {
                        Label("Sessions Menu", systemImage: "ellipsis.circle")
                    }
                }
            }
        }
    }
    
    private func createPredicate() -> NSPredicate {
        return FetchPredicate.create(from: [!selectedLabel.isEmpty ? (.label, selectedLabel) : nil])
    }
    
    private enum SessionSort {
        case project
        case startDate
    }
    
    private func sortDescriptors() -> [NSSortDescriptor] {
        switch sessionSort {
        case .project:
            return [NSSortDescriptor(keyPath: \Session.project, ascending: sortAscending)]
        case .startDate:
            return [NSSortDescriptor(keyPath: \Session.startDate, ascending: sortAscending)]
        }
    }
}

struct SessionsTabView_Previews: PreviewProvider {
    static var previews: some View {
        SessionsTabView()
    }
}
