//
//  ProjectSessions.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/18/22.
//

import SwiftUI

struct ProjectSessions: View {
    var project: Project
    @Environment (\.modelContext) private var modelContext
    
    var body: some View {
        // If there are no sessions or only one session that is incomplete, sessions.last?.endDate == nil.
        // If there is more than one session because sessions are sorted newest to oldest, sessions.last?.endDate != nil
        if project.projectSessions.isEmpty || project.projectSessions.last?.endDate == nil {
            ContentUnavailableView("No time tracking sessions have been completed for this project.", systemImage: "hourglass.bottomhalf.filled")
        } else {
            List {
                ForEach(project.projectSessions) { session in
                    if session.endDate != nil {
                        SessionRow(session: session)
                    }
                }
                .onDelete(perform: deleteSession)
            }
            .listStyle(.grouped)
            .toolbar {
                ShareLink(item: project.sessionsShareLinkItem) {
                    Label ("Export Sessions", systemImage: "square.and.arrow.up")
                }
                // TODO: Fix use of edit button crashing app.
//                EditButton()
            }
        }
    }
    
    func deleteSession(at offsets: IndexSet) {
        for offset in offsets {
            let session = project.projectSessions[offset]
            modelContext.delete(session)
        }
    }
}

struct ProjectSessionsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSessions(project: Project.preview)
    }
}
