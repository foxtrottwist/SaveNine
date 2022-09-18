//
//  TrackerView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/17/22.
//

import SwiftUI

struct TrackerView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var start: Date?
    @State var tracking = false
    
    let project: Project
    let session: Session?
    
    
    
    init(project: Project) {
        self.project = project
        
        if let session = project.projectSessions.last, session.endDate == nil {
                self.session = session
                
                _start = State(wrappedValue: session.startDate)
                _tracking = State(wrappedValue: true)
        } else {
            self.session = nil
        }
    }
    
    var body: some View {
        VStack {
            TimerView(start: start)
            
            HStack {
                Button("Cancel") {
                    withAnimation {
                        cancelSession()
                    }
                }
                .disabled(!tracking)
                
                Spacer(minLength: 100)
                
                if tracking {
                    Button("End Session") {
                        withAnimation {
                            endSession()
                        }
                    }
                } else {
                    Button("Start Session") {
                        withAnimation {
                            startSession()
                        }
                    }
                }
            }
            .padding()
            
            NavigationLink("Sessions", destination: SessionsView(sessions: project.projectSessions))
            
            Divider()
        }
    }
    
    func startSession() {
        start = Date()
        
        let session = Session(context: managedObjectContext)
        session.startDate = start
        session.project = project
        tracking = true
        
        dataController.save()
    }
    
    func endSession() {
        if let session = session {
            session.endDate = Date()
            if let startDate = start, let endDate = session.endDate {
                session.duration = endDate.timeIntervalSince(startDate)
                
                start = nil
                tracking = false
                
                dataController.save()
            }
        }
    }
    
    func cancelSession() {
        if let session = session {
            dataController.delete(session)
            start = nil
            tracking = false
            
            dataController.save()
        }
    }
}

struct TrackerView_Previews: PreviewProvider {
    static var previews: some View {
        TrackerView(project: Project.example)
    }
}
