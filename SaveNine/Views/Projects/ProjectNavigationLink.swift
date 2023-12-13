//
//  ProjectNavigationLink.swift
//  SaveNine
//
//  Created by Lawrence Horne on 12/4/23.
//

import SwiftData
import SwiftUI

struct ProjectNavigationLink: View {
    let project: Project
    @Query(filter: Project.predicate(tracking: true)) private var projects: [Project]
    
    private var tracking: Bool { !projects.isEmpty }

    var body: some View {
        NavigationLink(value: project) {
            ProjectRow(project: project)
                .swipeActions(allowsFullSwipe: false) {
                    let closed = project.closed ?? false
                    
                    if !closed && !tracking {
                        Button {
                            Timer.shared.start(for: project, date: .now, widget: .recentlyTracked)
                        } label: {
                            Label("Start", systemImage: "stopwatch")
                        }
                        .tint(.pawPawGreen)
                    }
                    
                    Button {
                        project.closed = !closed
                    } label: {
                        Label(closed ? "Open" : "Close", systemImage: closed ? "tray" : "archivebox")
                    }
                    .tint(closed ? .orange : .pawPawBlue)
                }
        }
    }
}

#Preview {
    ProjectNavigationLink(project: .init(name: "Hello There"))
}
