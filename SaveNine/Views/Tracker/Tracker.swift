//
//  Tracker.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/17/22.
//

import SwiftUI

struct Tracker: View {
    var project: Project
    @Environment (\.modelContext) private var modelContext
    @State private var label: String = DefaultLabel.none.rawValue
    @State private var start: Date?
    @State private var showingClearConfirm = false
    @State private var showingStopWatchSheet = false
    @State private var tracking = false
    
    init(project: Project) {
        self.project = project
        
        if let session = project.projectSessions.first {
            _label = State(wrappedValue: session.sessionLabel)
            
            if let tracking = project.tracking, tracking {
                _start = State(wrappedValue: session.startDate)
                _tracking = State(wrappedValue: tracking)
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
                            Text("Cancel")
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
                Button("Cancel Timer", role: .destructive) {
                    Task {
                        await cancelTimer()
                    }
                }
            }
        }
    }
    
    private func startTimer() {
        start = Date()
        tracking = true
        
        Timer.shared.start(for: project, date: start!)
        try! modelContext.save()
        
        WidgetKind.reload(.recentlyTracked)
    }
    
    private func stopTimer() async {
        start = nil
        tracking = false
        
        await Timer.shared.stop(for: project)
        try! modelContext.save()
         
        WidgetKind.reload(.recentlyTracked)
    }
    
    private func cancelTimer() async {
        start = nil
        tracking = false
        
        let currentSession = await Timer.shared.cancel(for: project)
        guard let currentSession else { return }
        
        modelContext.delete(currentSession)
        try! modelContext.save()
        
        WidgetKind.reload(.recentlyTracked)
    }
}

#Preview {
    Tracker(project: Project.preview)
        .environment(SessionLabelController())
        .modelContainer(for: [Project.self, Session.self, Tag.self], inMemory: true)
}
