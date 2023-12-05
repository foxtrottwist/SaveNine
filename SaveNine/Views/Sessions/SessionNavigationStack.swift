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
    @State private var predicate = #Predicate<Session> { $0.endDate != nil }
    @State private var selectedLabel: String = ""
    @State private var selectedName: String = ""
    @Query(filter: #Predicate<Project> { $0.closed != true }, sort: \Project.name) private var projects: [Project]
    
    var body: some View {
        NavigationStack {
            QueryView(
                FetchDescriptor<Session>(predicate: predicate, sortBy: [SortDescriptor(\.endDate, order: .reverse)])
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
                                Text(session.project?.name ?? "")
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
                    Button {
                        selectedLabel = ""
                        selectedName = ""
                        predicate = #Predicate<Session> { $0.endDate != nil }
                    } label: {
                        Label("Clear Filter", systemImage: "xmark.circle")
                    }
                    
                    Menu {
                        SessionLabelPicker(selectedLabel: $selectedLabel, disabled: true)
                            .onChange(of: selectedLabel) { filter() }
                    } label: {
                        Text("Filter By Label")
                    }
                    Menu {
                        Picker("Filter By Name", selection: $selectedName) {
                            ForEach(projects) { project in
                                Text(project.name).tag(project.name)
                            }
                        }
                        .onChange(of: selectedName) { filter() }
                    } label: {
                        Text("Filter By Project Name")
                    }
                } label: {
                    Label("Filters Menu", systemImage: "line.3.horizontal.decrease.circle")
                }
            }
        }
    }
    
    private func filter() {
        if selectedLabel.isEmpty && selectedName.isEmpty {
            return
        }
        if selectedLabel.isEmpty {
            predicate = #Predicate<Session> { $0.endDate != nil && $0.project?.name == selectedName }
            return
        }
        if selectedName.isEmpty {
            predicate = #Predicate<Session> { $0.endDate != nil && $0.label == selectedLabel }
            return
        }
        predicate = #Predicate<Session> { $0.endDate != nil && $0.label == selectedLabel && $0.project?.name == selectedName }
    }
    
    static let tag: String? = "Sessions"
}

#Preview {
    SessionNavigationStack()
}
