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
    @State private var showingCancelConfirm = false
    @State private var showingStopWatchSheet = false
    
    init(project: Project) {
        self.project = project
        
        if let session = project.projectSessions.first {
            _label = State(wrappedValue: session.displayLabel)
            
            if project.tracking ?? false {
                _start = State(wrappedValue: session.startDate)
            }
        }
    }
    
    var body: some View {
        StopwatchSafeAreaInset(
            start: start,
            tracking: project.tracking ?? false,
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
                            showingCancelConfirm.toggle()
                        } label: {
                            Text("Cancel")
                                .padding()
                                .contentShape(Circle())
                        }
                    }
                    .padding()
                    .background(.ultraThickMaterial)
                    .clipShape(Circle())
                    .disabled(!(project.tracking ?? false))
                    
                    Spacer()
                    
                    VStack {
                        if project.tracking ?? false {
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
            .confirmationDialog("Are you sure you want to cancel the timer? No time will be tracked.", isPresented: $showingCancelConfirm, titleVisibility: .visible) {
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
        project.tracking = true
        
        Timer.shared.start(for: project, date: start!, label: label)
        try! modelContext.save()
        
        WidgetKind.reload(.recentlyTracked)
    }
    
    private func stopTimer() async {
        start = nil
        project.tracking = false
        
        await Timer.shared.stop(for: project, label: label)
        try! modelContext.save()
        
        WidgetKind.reload(.recentlyTracked)
    }
    
    private func cancelTimer() async {
        start = nil
        project.tracking = false
        
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
