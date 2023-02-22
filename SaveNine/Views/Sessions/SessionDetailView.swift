//
//  SessionDetailView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 11/8/22.
//

import SwiftUI

struct SessionDetailView: View {
    let session: Session
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataController: DataController
    
    @State private var duration: Double
    @State private var endDate: Date
    @State private var label: String
    @State private var startDate: Date
    
    init(session: Session) {
        self.session = session
        
        _duration = State(wrappedValue: session.duration)
        _endDate = State(wrappedValue: session.endDate ?? Date())
        _label = State(wrappedValue: session.sessionLabel)
        _startDate = State(wrappedValue: session.startDate ?? Date())
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    SessionLabelPickerView(selectedLabel: $label)
                }
                
                Section {
                    DatePicker("Starts", selection: $startDate, in: ...endDate, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("Ends", selection: $endDate, in: startDate..., displayedComponents: [.date, .hourAndMinute])
                }
                
                Section {
                    Text(duration.formattedDuration)
                } header: {
                    Text("Duration")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Session Details")
            .onChange(of: startDate, perform: { _ in updateDuration() })
            .onChange(of: endDate, perform: { _ in updateDuration() })
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", action: updateSession)
                        .bold()
                }
            }
        }
    }
    
    private func updateDuration() {
        duration = endDate.timeIntervalSince(startDate)
    }
    
    private func updateSession() {
        session.project?.objectWillChange.send()
        session.label = label
        session.startDate = startDate
        session.endDate = endDate
        session.duration = endDate.timeIntervalSince(startDate)
        
        dataController.save()
        dismiss()
        
        if let sessionProject = session.project, let project = ProjectWidget.mostRecentlyTrackedProject {
            if project.id == sessionProject.id {
                let projectWidget = ProjectWidget(
                    id: project.id,
                    name: sessionProject.projectName,
                    modifiedDate: endDate,
                    sessionCount: sessionProject.projectSessions.count,
                    timeTracked: sessionProject.projectFormattedTotalDuration
                )
                
                projectWidget.writeMostRecentlyTrackedWidget()
            }
        }
    }
}

struct SessionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SessionDetailView(session: Session.Example)
            .environmentObject(SessionLabelController.preview)
    }
}
