//
//  Tracker.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/17/22.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct Tracker: View {
    @ObservedObject var project: Project

    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataController: DataController
    
    @State private var label: String = DefaultLabel.none.rawValue
    @State private var liveActivity: Activity<TrackerAttributes>?
    @State private var session: Session?
    @State private var start: Date?
    @State private var showingClearConfirm = false
    @State private var tracking = false
    
    init(project: Project) {
        self.project = project
        
        if let session = project.projectSessions.first {
            _label = State(wrappedValue: session.sessionLabel)
            
            if project.tracking {
                _session = State(wrappedValue: session)
                _start = State(wrappedValue: session.startDate)
                _tracking = State(wrappedValue: project.tracking)
            }
        }
    }
    
    var body: some View {
        VStack {
            SessionLabelPicker(selectedLabel: $label)
            TimerTimelineView(start: start)
            
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
            session.label = label
            
            if let startDate = start, let endDate = session.endDate {
                session.duration = endDate.timeIntervalSince(startDate)
                
                start = nil
                tracking = false
                
                dataController.save()
                
                let projectWidget = ProjectWidget(
                    id: project.id!,
                    name: project.displayName,
                    modifiedDate: endDate,
                    sessionCount: project.projectSessions.count,
                    timeTracked: project.timeTracked
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
        }
    }
   
    private func requestLiveActivity(date: Date) {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            let attributes = TrackerAttributes(projectName: project.displayName, projectId: project.id!)
            let contentState = ActivityContent(state: TrackerAttributes.ContentState(start: date), staleDate: nil)
            
            do {
               try liveActivity = Activity.request(attributes: attributes, content: contentState)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateLiveActivity(date: Date?) async {
        if let date {
            await liveActivity?.update(ActivityContent(state: TrackerAttributes.ContentState(start: date), staleDate: nil))
        }
    }
    
    private func endLiveActivity(date: Date = Date()) async {
        for activity in Activity<TrackerAttributes>.activities {
            await activity.end(ActivityContent(state: TrackerAttributes.ContentState(start: date), staleDate: nil), dismissalPolicy: .immediate)
        }
    }
}

#Preview {
    Tracker(project: Project.preview)
        .environment(SessionLabelController())
}
