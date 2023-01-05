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
    
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var duration: Double
    
    init(session: Session) {
        self.session = session
        
        _startDate = State(wrappedValue: session.startDate!)
        _endDate = State(wrappedValue: session.endDate!)
        _duration = State(wrappedValue: session.duration)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("Starts", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("Ends", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
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
        session.startDate = startDate
        session.endDate = endDate
        session.duration = endDate.timeIntervalSince(startDate)
        
        dataController.save()
        dismiss()
    }
}

struct SessionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SessionDetailView(session: Project.example.projectSessions.first!)
    }
}
