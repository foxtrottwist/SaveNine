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
    
    @State private var showingSessionDetailView = false
    
    var body: some View {
            if sessions.isEmpty || sessions.first?.endDate == nil {
                NoContentView(message: "No time tracking sessions have been completed for this project.")
                    .padding()
            } else {
                List {
                    ForEach(sessions) { session in
                        if session.endDate != nil {
                            SessionRowView(session: session)
                        }
                    }
                    .onDelete(perform: deleteSession)
                }
                .toolbar {
                    ShareLink(item: sharedSessions) {
                        Label ("Export Sessions", systemImage: "square.and.arrow.up")
                    }
                    
                    EditButton()
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
