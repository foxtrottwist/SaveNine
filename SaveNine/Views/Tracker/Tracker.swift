//
//  Tracker.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/17/22.
//

import SwiftUI
import WidgetKit

struct Tracker: View {
    var project: Project
    @Environment (\.modelContext) private var modelContext
    @State private var label: String = DefaultLabel.none.rawValue
    @State private var session: Session?
    @State private var start: Date?
    @State private var showingClearConfirm = false
    @State private var showingStopWatchSheet = false
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
        StopwatchSafeAreaInset(
            start: start,
            tracking: tracking,
            startAction: startTimer,
            stopAction: stopTimer,
            onTap: { showingStopWatchSheet.toggle() }
        )
        .sheet(isPresented: $showingStopWatchSheet) {
            VStack {
                SessionLabelPicker(selectedLabel: $label)
                    .padding(.top)
                TimerTimelineView(start: start)
                    .font(.largeTitle)
                
                HStack {
                    VStack {
                        Button {
                            showingClearConfirm.toggle()
                        } label: {
                            Text("Clear")
                                .padding()
                                .contentShape(Circle())
                        }
                    }
                    .padding()
                    .background(.ultraThickMaterial)
                    .clipShape(Circle())
                    .disabled(!tracking)
                    
                    Spacer()
                    
                    VStack {
                        if tracking {
                            Button {
                                Task {
                                    await stopTimer()
                                }
                            } label: {
                                Text("Stop")
                                    .padding()
                                    .contentShape(Circle())
                            }
                        } else {
                            Button(action: startTimer) {
                                Text("Start")
                                    .padding()
                                    .contentShape(Circle())
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThickMaterial)
                    .clipShape(Circle())
                }
                .padding()
            }
            .presentationDetents([.fraction(0.4)])
            .presentationDragIndicator(.visible)
            .confirmationDialog("Are you sure you want to clear the timer? No time will be tracked.", isPresented: $showingClearConfirm, titleVisibility: .visible) {
                Button("Clear Timer", role: .destructive) {
                    Task {
                        await clearTimer()
                    }
                }
            }
        }
    }
    
    private func startTimer() {
           start = Date()
           tracking = true
           let session = Session(label: label, startDate: start, project: project)
           self.session = session
           project.sessions?.append(session)
        
           TimerActivity.shared.requestLiveActivity(project: project, date: start!)
       }
       
       private func stopTimer() async {
           if let session = session, let startDate = start {
               let endDate = Date()
               
               project.modificationDate = endDate
               session.endDate = endDate
               session.label = label
               session.duration = endDate.timeIntervalSince(startDate)
               start = nil
               tracking = false
               
               WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.RecentlyTracked.rawValue)
           }
           
           
           await TimerActivity.shared.endLiveActivity()
       }
    
    private func clearTimer() async {
        if let session = session {
            modelContext.delete(session)
            start = nil
            tracking = false
        }
        
        await TimerActivity.shared.endLiveActivity()
    }
}

#Preview {
    Tracker(project: Project.preview)
        .environment(SessionLabelController())
        .modelContainer(for: [Project.self, Session.self, Tag.self], inMemory: true)
}
