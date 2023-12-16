//
//  Tracker.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/17/22.
//

import SwiftData
import SwiftUI

struct Tracker: View {
    var project: Project
    @AppStorage(StorageKey.timerHaptic.rawValue) private var timerHaptics: Bool = true
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext
    @State private var label: String = DefaultLabel.none.rawValue
    @State private var showingStopWatchSheet = false
    @Query private var sessions: [Session]
    
    private var tracking: Bool { project.tracking ?? false }
    
    private var currentSession: Session? {
        if let session = sessions.first, session.endDate == nil && tracking {
            session
        } else {
            nil
        }
    }
    
    private var lastSession: Session? {
        if currentSession == nil {
            sessions.first
        } else {
            if let session = sessions.last, session.endDate != nil {
                session
            } else {
                nil
            }
        }
    }
    
    private var currentLabel: String {
        currentSession?.displayLabel ?? lastSession?.displayLabel ?? label
    }
    
    init(project: Project) {
        self.project = project
        _sessions = Query(Session.fetchLastTwoBy(projectID: project.id))
    }
    
    var body: some View {
        StopwatchSafeAreaInset(label: label, start: currentSession?.startDate, tracking: tracking) {
            startTimer()
        } stopAction: {
            stopTimer()
        } onTapGesture: {
            showingStopWatchSheet.toggle()
        }
        .onAppear { label = currentLabel }
        .sensoryFeedback(.success, trigger: tracking) { _, _ in
            timerHaptics
        }
        .sheet(isPresented: $showingStopWatchSheet) {
            VStack {
                SessionLabelPicker(selectedLabel: $label)
                    .padding(.top)
                
                TimerTimelineView(start: currentSession?.startDate)
                    .font(.largeTitle)
                
                HStack {
                    CancelButton {
                        cancelTimer()
                        showingStopWatchSheet = false
                    }
                    .disabled(!tracking)
                    
                    Spacer()
                    
                    VStack {
                        if tracking {
                            Button {
                                stopTimer()
                            } label: {
                                Text("Stop")
                                    .padding()
                            }
                        } else {
                            Button(action: startTimer) {
                                Text("Start")
                                    .padding()
                            }
                        }
                    }
                    .timerButton()
                }
                .padding()
            }
            .presentationDetents([.fraction(0.4)])
            .presentationDragIndicator(.visible)
        }
    }
    
    private func cancelTimer() {
        if let currentSession {
            Timer.shared.cancel(session: currentSession, modelContext: modelContext, widget: .recentlyTracked)
        }
    }
    
    private func startTimer() {
        Timer.shared.start(for: project, date: .now, label: label, widget: .recentlyTracked)
    }
    
    private func stopTimer() {
        if let currentSession {
            Timer.shared.stop(session: currentSession, widget: .recentlyTracked)
        }
    }
}

#Preview {
    Tracker(project: Project.preview)
}

// Moved cancel button to separate view to solve confirmationDialog reappearing momentarily after pressing one of the dialog buttons.
fileprivate struct CancelButton: View {
    let action: () -> Void
    @State private var showingCancelConfirm = false
    
    var body: some View {
        VStack {
            Button {
                showingCancelConfirm.toggle()
            } label: {
                Text("Cancel")
                    .padding()
            }
        }
        .timerButton()
        .confirmationDialog("Are you sure you want to cancel the timer? No time will be tracked.", isPresented: $showingCancelConfirm, titleVisibility: .visible) {
            Button("Cancel Timer", role: .destructive) {
                action()
            }
        }
    }
}

fileprivate struct TimerButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.ultraThickMaterial)
            .clipShape(Circle())
    }
}

fileprivate extension VStack {
    func timerButton() -> some View {
        return modifier(TimerButton())
    }
}
