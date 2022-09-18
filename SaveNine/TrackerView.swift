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
    
    let project: Project
    let session: Session?
    let digit = "0"
    let width = CGFloat(60)
    
    
    
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
            if let start = start {
                TimelineView(.periodic(from: start, by: 1)) { _ in
                    HStack {
                        DigitView(digit: String(elapsedTime(since: start, in: .hours).split(separator: "").first!))
                        DigitView(digit: String(elapsedTime(since: start, in: .hours).split(separator: "").last!))
                        Text(":")
                        DigitView(digit: String(elapsedTime(since: start, in: .minutes).split(separator: "").first!))
                        DigitView(digit: String(elapsedTime(since: start, in: .minutes).split(separator: "").last!))
                        Text(":")
                        DigitView(digit: String(elapsedTime(since: start, in: .seconds).split(separator: "").first!))
                        DigitView(digit: String(elapsedTime(since: start, in: .seconds).split(separator: "").last!))
                    }
                    .font(.largeTitle)
                    .padding()
                }
            } else {
                HStack {
                    DigitView(digit: digit)
                    DigitView(digit: digit)
                    Text(":")
                    DigitView(digit: digit)
                    DigitView(digit: digit)
                    Text(":")
                    DigitView(digit: digit)
                    DigitView(digit: digit)
                }
                .font(.largeTitle)
                .padding()
            }
            
            HStack {
                Button("Cancel") {
                    withAnimation {
                        cancelSession()
                    }
                }
                .disabled(!tracking)
                
                Spacer(minLength: 100)
                
                if tracking {
                    Button("End Session") {
                        withAnimation {
                            endSession()
                        }
                    }
                } else {
                    Button("Start Session") {
                        withAnimation {
                            startSession()
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    func startSession() {
        start = Date()
        
        let session = Session(context: managedObjectContext)
        session.startDate = start
        session.project = project
        tracking = true
        
        dataController.save()
    }
    
    func endSession() {
        if let session = session {
            session.endDate = Date()
            
            start = nil
            tracking = false
            
            dataController.save()
        }
    }
    
    func cancelSession() {
        if let session = session {
            dataController.delete(session)
            start = nil
            tracking = false
            
            dataController.save()
        }
    }
    
    enum FormmattedTime {
        case hours, minutes, seconds
    }
    
    func elapsedTime(since start: Date, in format: FormmattedTime ) -> String {
        let elapsedTime = Int(-start.timeIntervalSinceNow.rounded())
        let hours = elapsedTime / 60 / 60
        let minutes = (elapsedTime - (hours * 60 * 60)) / 60
        
        switch format {
        case .hours:
            return hours <= 9 ? "\(0)\(hours)" : "\(hours)"
        case .minutes:
            return minutes <= 9 ? "\(0)\(minutes)" : "\(minutes)"
        case .seconds:
            return seconds(elapsedTime)
        }
    }
    
    func seconds(_ seconds: Int) -> String {
        if seconds > 60 {
            let remainder = seconds % 60
            return remainder <= 9 ? "\(0)\(remainder)" : "\(remainder)"
        } else if seconds > 9 {
            return "\(seconds)"
        }
        
        return "\(0)\(seconds)"
    }
}

struct TrackerView_Previews: PreviewProvider {
    static var previews: some View {
        TrackerView(project: Project.example)
    }
}
