//
//  SessionsView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/18/22.
//

import SwiftUI

struct SessionsView: View {
    let sessions: [Session]
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        List {
            if sessions.isEmpty {
                Text("No time tracking seesions have been completed for this project.")
                    .italic()
                    .foregroundColor(.secondary)
            } else {
                ForEach(sessions) { session in
                    if let duration = session.duration, let startDate = session.startDate, session.endDate != nil {
                        VStack(alignment: .leading) {
                            Text(startDate.formatted())
                                .font(.callout)
                                .foregroundColor(.secondary)
                            Text(format(duration: duration))
                        }
                    }
                }
                .onDelete(perform: deleteSession)
            }
        }
    }
    
    func format(duration: Double) -> String {
        let time = Int(duration.rounded())
        let hours = time / 60 / 60
        let minutes = (time - (hours * 60 * 60)) / 60
        
        return "\(hours):\(minutes)"
    }
    
    func deleteSession(at offsets: IndexSet) {
        for offset in offsets {
            let session = sessions[offset]
            dataController.delete(session)
            
            dataController.save()
        }
    }
}

struct SessionsView_Previews: PreviewProvider {
    static var previews: some View {
        SessionsView(sessions: Project.example.projectSessions)
    }
}
