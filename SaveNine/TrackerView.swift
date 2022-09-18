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
                    let hours = digitsFrom(string: elapsedTime(since: start, in: .hours))
                    let minutes = digitsFrom(string: elapsedTime(since: start, in: .minutes))
                    let seconds = digitsFrom(string: elapsedTime(since: start, in: .seconds))
                    
                    HStack {
                        DigitView(digit: hours.0)
                        DigitView(digit: hours.1)
                        Text(":")
                        DigitView(digit: minutes.0)
                        DigitView(digit: minutes.1)
                        Text(":")
                        DigitView(digit: seconds.0)
                        DigitView(digit: seconds.1)
                    }
                    .font(.largeTitle)
                    .padding()
                }
            } else {
                HStack {
                    DigitView(digit: "0")
                    DigitView(digit: "0")
                    Text(":")
                    DigitView(digit: "0")
                    DigitView(digit: "0")
                    Text(":")
                    DigitView(digit: "0")
                    DigitView(digit: "0")
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
            if let startDate = start, let endDate = session.endDate {
                session.duration = endDate.timeIntervalSince(startDate)
                
                start = nil
                tracking = false
                
                dataController.save()
            }
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
            return hours <= 9 ? "0\(hours)" : "\(hours)"
        case .minutes:
            return minutes <= 9 ? "0\(minutes)" : "\(minutes)"
        case .seconds:
            return seconds(elapsedTime)
        }
    }
    
    func seconds(_ seconds: Int) -> String {
        if seconds > 60 {
            let remainder = seconds % 60
            return remainder <= 9 ? "0\(remainder)" : "\(remainder)"
        } else if seconds > 9 {
            return "\(seconds)"
        }
        
        return "0\(seconds)"
    }
    
    func digitsFrom(string: String) -> (String, String) {
        let split = string.split(separator: "")

        return (String(split.first ?? "0"), String(split.last ?? "0"))
    }
}

struct TrackerView_Previews: PreviewProvider {
    static var previews: some View {
        TrackerView(project: Project.example)
    }
}
