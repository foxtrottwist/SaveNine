//
//  TrackerView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/17/22.
//

import SwiftUI

struct TrackerView: View {
    let project: Project
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var session: Session?
    @State var start: Date?
    @State var showingClearConfirm = false
    @State var tracking = false
    
    init(project: Project) {
        self.project = project
        
        if let session = project.projectSessions.last, session.endDate == nil {
                _session = State(wrappedValue: session)
                _start = State(wrappedValue: session.startDate)
                _tracking = State(wrappedValue: true)
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
                    Button("Stop Timer") {
                        withAnimation {
                            stopTimer()
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
                let timeTracked = format(duration: project.projectTotalDuration, in: .hours) + format(duration: project.projectTotalDuration, in: .minutes)
                
                    VStack {
                        Text("*Sessions*:")
                            .font(.callout)
                            .fontWeight(.light)
                        
                        Text("\(tracking ? project.projectSessions.count - 1 : project.projectSessions.count)")
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("*Time Tracked*:")
                            .font(.callout)
                            .fontWeight(.light)
                        
                        if timeTracked.isEmpty {
                            Text("None")
                        } else {
                            Text(timeTracked)
                        }
                    }
            }
            .padding()
        }
        .confirmationDialog("Are you sure you want to clear the timer? No time will be tracked.", isPresented: $showingClearConfirm, titleVisibility: .visible) {
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
        
        dataController.save()
        
        tracking = true
        self.session = session
    }
    
    func stopTimer() {
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
