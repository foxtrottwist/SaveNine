//
//  SessionsView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/18/22.
//

import SwiftUI

struct SessionsView: View {
    let sessions: [Session]
    let sharedSessions: String
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
            if sessions.isEmpty || sessions.first?.endDate == nil {
                VStack {
                    Text("No time tracking sessions have been completed for this project.")
                        .italic()
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else {
                List {
                    ForEach(sessions) { session in
                        if let duration = session.duration, let startDate = session.startDate, session.endDate != nil {
                            VStack(alignment: .leading) {
                                Text(startDate.formatted(date: .abbreviated, time: .shortened))
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                                Text(longFormat(duration: duration))
                            }
                        }
                    }
                    .onDelete(perform: deleteSession)
                }
                .toolbar {
                    EditButton()
                    
                    ShareLink(item: sharedSessions) {
                        Label ("Export Sessions", systemImage: "square.and.arrow.up")
                    }
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
        SessionsView(sessions: Project.example.projectSessions, sharedSessions: "")
    }
}
