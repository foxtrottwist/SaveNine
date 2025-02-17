//
//  SessionDetail.swift
//  SaveNine
//
//  Created by Lawrence Horne on 11/8/22.
//

import SwiftUI

struct SessionDetail: View {
    let session: Session
    @Environment(\.dismiss) private var dismiss
    @State private var duration: Double
    @State private var endDate: Date
    @State private var label: String
    @State private var startDate: Date
    
    init(session: Session) {
        self.session = session
        _duration = State(wrappedValue: session.duration ?? 0)
        _endDate = State(wrappedValue: session.endDate ?? Date())
        _label = State(wrappedValue: session.displayLabel)
        _startDate = State(wrappedValue: session.startDate ?? Date())
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    SessionLabelPicker(selectedLabel: $label)
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
            .onChange(of: endDate) { updateDuration() }
            .onChange(of: startDate) { updateDuration() }
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
        if label != session.displayLabel {
            Marker.updateLastUsed(for: label)
        }
       
        session.label = label
        session.startDate = startDate
        session.endDate = endDate
        session.duration = endDate.timeIntervalSince(startDate)
        dismiss()
        
        if let sessionProject = session.project, let project = Project.recentlyTracked {
            if project.id == sessionProject.id {
                project.modificationDate = endDate
            }
        }
        
        WidgetKind.reload(.recentlyTracked)
    }
}

#Preview {
    SessionDetail(session: Session.preview)
}
