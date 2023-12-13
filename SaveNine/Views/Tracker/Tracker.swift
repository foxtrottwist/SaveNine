//
//  Tracker.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/17/22.
//

import SwiftData
import SwiftUI

struct Tracker: View {
    var project: Project?
    @AppStorage(StorageKey.timerHaptic.rawValue) private var timerHaptics: Bool = true
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext
    @State private var label: String = DefaultLabel.none.rawValue
    @State private var showingStopWatchSheet = false
    @Query private var sessions: [Session]
    
    private var tracking: Bool { project?.tracking ?? false }
    
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
    
    
    init(project: Project?) {
        self.project = project
        _sessions = Query(Session.fetchLastTwoBy(projectID: project?.id))
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.ultraThickMaterial)
            
            if !showingStopWatchSheet {
                ScrollingText(label)
                    .font(.subheadline)
            }
            
            HStack {
                HStack {
                    TimerTimelineView(start: currentSession?.startDate)
                        .font(.title)
                    Spacer()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    showingStopWatchSheet.toggle()
                }
                
                
                if tracking {
                    Button {
                        Task {
                            await stopTimer()
                        }
                    } label: {
                        Label("Stop", systemImage: "stop.fill")
                    }
                } else {
                    Button(action: startTimer) {
                        Label("Start", systemImage: "play.fill")
                    }
                }
            }
            .padding()
        }
        .onAppear { label = currentLabel }
        .frame(height: 70)
        .padding()
        .shadow(color: colorScheme == .light ? .secondary : .clear, radius: 10, x: 0, y: 15)
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
                        Task {
                            await cancelTimer()
                        }
                    }
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
    
    private func cancelTimer() async {
        if let currentSession, let project {
            modelContext.delete(currentSession)
            
            project.tracking = false
            WidgetKind.reload(.recentlyTracked)
            await TimerActivity.shared.endLiveActivity(date: .now)
        }
    }
    
    private func startTimer() {
        if let project {
            let startDate = Date()
            let _ = Session(label: label, startDate: startDate, project: project)
            project.tracking = true
            
            TimerActivity.shared.requestLiveActivity(project: project, date: startDate)
            WidgetKind.reload(.recentlyTracked)
        }
    }
    
    private func stopTimer() async {
        if let currentSession, let project {
            project.tracking = false
            
            let endDate = Date()
            currentSession.endDate = endDate
            currentSession.duration = endDate.timeIntervalSince(currentSession.startDate!)
            currentSession.label = label
            project.modificationDate = endDate
            
            WidgetKind.reload(.recentlyTracked)
            await TimerActivity.shared.endLiveActivity(date: endDate)
        }
    }
}

#Preview {
    Tracker(project: Project.preview)
        .modelContainer(for: [Project.self, Session.self, Tag.self], inMemory: true)
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
