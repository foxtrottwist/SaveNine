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
    
    init(session: Session) {
        self.session = session
        
        _startDate = State(wrappedValue: session.startDate!)
        _endDate = State(wrappedValue: session.endDate!)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("Starts", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("Ends", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Session Details")
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
    
    func updateSession() {
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
