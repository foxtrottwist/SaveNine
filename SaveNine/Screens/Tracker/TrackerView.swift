//
//  TrackerView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/17/22.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct TrackerView: View {
    @ObservedObject var project: Project

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var liveActivity: Activity<TrackerAttributes>?
    @State private var session: Session?
    @State private var start: Date?
    @State private var showingClearConfirm = false
    @State private var tracking = false
    
    init(project: Project) {
        self.project = project
        
        if let session = project.projectSessions.first, project.tracking {
                _session = State(wrappedValue: session)
                _start = State(wrappedValue: session.startDate)
                _tracking = State(wrappedValue: project.tracking)
        }
    }
    
    var body: some View {
        VStack {
            SessionLabelPickerView(selectedLabel: "", sessionLabels: [])
            TimerView(start: start)
            
            HStack {
                Button("Clear") {
                    showingClearConfirm.toggle()
                }
                .disabled(!tracking)
                
                Spacer()
                
                if tracking {
                    Button("Stop Timer") {
                        stopTimer()
                        
                        Task {
                            await endLiveActivity()
                        }
                    }
                } else {
                    Button("Start Timer") {
                        startTimer()
                    }
                    .disabled(project.closed)
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
                clearTimer()
                
                Task {
                    await endLiveActivity()
                }
            }
        }
    }
    
    private func startTimer() {
        start = Date()
        
        let session = Session(context: managedObjectContext)
        session.startDate = start
        session.project = project
        session.project?.objectWillChange.send()
        
        dataController.save()
        
        tracking = true
        self.session = session
        
        requestLiveActivity(date: start!)
    }
    
    private func stopTimer() {
        if let session = session {
            session.project?.objectWillChange.send()
            session.endDate = Date()
            
            if let startDate = start, let endDate = session.endDate {
                session.duration = endDate.timeIntervalSince(startDate)
                
                start = nil
                tracking = false
                
                dataController.save()
                
                let projectWidget = ProjectWidget(
                    id: project.id!,
                    name: project.projectName,
                    modifiedDate: endDate,
                    sessionCount: project.projectSessions.count,
                    timeTracked: project.projectFormattedTotalDuration
                )
                
                projectWidget.writeMostRecentlyTrackedWidget()
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
   
    private func requestLiveActivity(date: Date) {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            let attributes = TrackerAttributes(projectName: project.projectName, projectId: project.id!)
            let contentState = TrackerAttributes.ContentState(start: date)
            
            do {
               try liveActivity = Activity.request(attributes: attributes, contentState: contentState)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateLiveActivity(date: Date?) async {
        if let date {
            await liveActivity?.update(using: TrackerAttributes.ContentState(start: date))
        }
    }
    
    private func endLiveActivity(date: Date = Date()) async {
        for activity in Activity<TrackerAttributes>.activities {
            await activity.end(using: TrackerAttributes.ContentState(start: date), dismissalPolicy: .immediate)
        }
    }
}

struct TrackerView_Previews: PreviewProvider {
    static var previews: some View {
        TrackerView(project: Project.example)
    }
}
