//
//  ProjectSessionsView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/18/22.
//

import SwiftUI

struct ProjectSessionsView: View {
    @ObservedObject var project: Project
    @EnvironmentObject private var dataController: DataController
    
    var body: some View {
        // If there are no sessions or only one session that is incomplete, sessions.last?.endDate == nil.
        // If there is more than one session because sessions are sorted newest to oldest, sessions.last?.endDate != nil
        if project.projectSessions.isEmpty || project.projectSessions.last?.endDate == nil {
            NoContentView(message: "No time tracking sessions have been completed for this project.")
                .padding()
        } else {
            List {
                ForEach(project.projectSessions) { session in
                    if session.endDate != nil {
                        SessionRowView(session: session)
                    }
                }
                .onDelete(perform: deleteSession)
            }
            .listStyle(.grouped)
            .toolbar {
                ShareLink(item: project.projectShareSessions) {
                    Label ("Export Sessions", systemImage: "square.and.arrow.up")
                }
                EditButton()
            }
        }
    }
    
    func deleteSession(at offsets: IndexSet) {
        for offset in offsets {
            let session = project.projectSessions[offset]
            session.project?.objectWillChange.send()
            dataController.delete(session)
        }
    }
}

struct ProjectSessionsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSessionsView(project: Project.example)
    }
}
