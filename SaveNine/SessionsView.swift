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
                            Text(startDate.formatted(date: .abbreviated, time: .shortened))
                                .font(.callout)
                                .foregroundColor(.secondary)
                            Text("\(format(duration: duration, in: .hours)) \(format(duration: duration, in: .minutes)) \(format(duration: duration, in: .seconds))")
                        }
                    }
                }
                .onDelete(perform: deleteSession)
            }
        }
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
