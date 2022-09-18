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
    @State var showingClearConfirm = false
    
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
                Button("Clear") {
                    withAnimation {
                        showingClearConfirm.toggle()
                    }
                }
                .disabled(!tracking)
                
                Spacer()
                
                if tracking {
                    Button("End Timer") {
                        withAnimation {
                            endTimer()
                        }
                    }
                } else {
                    Button("Start Timer") {
                        withAnimation {
                            startTimer()
                        }
                    }
                }
            }
            .padding()

            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(project.projectSessions.count) Sessions")
                        .padding(.bottom)
                    Text("\(format(duration: project.projectTotalDuration)) Tracked")
                        .font(.callout)
                }
                Spacer()
            }
            .padding(.vertical)
            
            NavigationLink("View Sessions", destination: SessionsView(sessions: project.projectSessions))
        }
        .confirmationDialog("Are you sure you want to clear the timer?", isPresented: $showingClearConfirm, titleVisibility: .visible) {
            Button("Clear Timer", role: .destructive) {
                clearTimer()
            }
        }
    }
    
    func startTimer() {
        start = Date()
        
        let session = Session(context: managedObjectContext)
        session.startDate = start
        session.project = project
        tracking = true
        
        dataController.save()
    }
    
    func endTimer() {
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
    
    func clearTimer() {
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
