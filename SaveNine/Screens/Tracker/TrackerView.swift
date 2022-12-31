//
//  TrackerView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/17/22.
//

import ActivityKit
import SwiftUI

struct TrackerView: View {
    let project: Project
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var liveActivity: Activity<TrackerAttributes>?
    @State var session: Session?
    @State var start: Date?
    @State var showingClearConfirm = false
    @State var tracking = false
    
    init(project: Project) {
        self.project = project
        
        if let session = project.projectSessions.first, session.endDate == nil {
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
                        Task {
                            await stopLiveActivity()
                            stopTimer()
                        }
                    }
                } else {
                    Button("Start Timer") {
                        startTimer()
                    }
                }
            }
            .padding()

            Divider()
            
            HStack {
                VStack {
                    Text("Sessions:")
                        .font(.callout)
                        .fontWeight(.light)
                        .italic()
                    
                    Text("\(tracking ? project.projectSessions.count - 1 : project.projectSessions.count)")
                }
                
                Spacer()
                
                VStack {
                    Text("Time Tracked:")
                        .font(.callout)
                        .fontWeight(.light)
                        .italic()
                    
                    Text(project.projectFormattedTotalDuration)
                }
            }
            .padding()
        }
        .confirmationDialog("Are you sure you want to clear the timer? No time will be tracked.", isPresented: $showingClearConfirm, titleVisibility: .visible) {
            Button("Clear Timer", role: .destructive) {
                Task {
                    await stopLiveActivity()
                    clearTimer()
                }
            }
        }
    }
    
    private func startTimer() {
        start = Date()
        
        let session = Session(context: managedObjectContext)
        session.startDate = start
        session.project = project
        
        dataController.save()
        
        tracking = true
        self.session = session
        
        startLiveActivity(date: start!)
    }
    
    private func stopTimer() {
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
    
    private func clearTimer() {
        if let session = session {
            dataController.delete(session)
            start = nil
            tracking = false
            
            dataController.save()
        }
    }
   
    private func startLiveActivity(date: Date) {
        let attributes = TrackerAttributes(projectName: project.projectName, projectId: project.id!)
        let contentState = TrackerAttributes.ContentState(start: date)
        
        do {
           try liveActivity = Activity.request(attributes: attributes, contentState: contentState)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func updateLiveActivity(date: Date?) async {
        if let date {
            await liveActivity?.update(using: TrackerAttributes.ContentState(start: date))
        }
    }
    
    private func stopLiveActivity(date: Date = Date()) async {
        await liveActivity?.end(using: TrackerAttributes.ContentState(start: date), dismissalPolicy: .immediate)
    }
}

struct TrackerView_Previews: PreviewProvider {
    static var previews: some View {
        TrackerView(project: Project.example)
    }
}
