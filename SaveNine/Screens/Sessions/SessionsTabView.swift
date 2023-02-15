//
//  SessionsTabView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/13/23.
//

import SwiftUI

struct SessionsTabView: View {
    static let tag: String? = "Sessions"

    let sortDescriptors = [NSSortDescriptor(keyPath: \Session.startDate, ascending: false)]
    
    var body: some View {
        NavigationStack {
            FetchRequestView(Session.fetchSessions(predicate: FetchPredicate.create(from: []), sortDescriptors: sortDescriptors)) { sessions in
                List(sessions) { session in
                    VStack(alignment: .leading) {
                        Text(session.project?.projectName ?? "")
                            .font(.headline)
                        
                        SessionRowView(session: session)
                    }
                    
                }
                .listStyle(.grouped)
                .navigationTitle("Sessions")
            }
        }
    }
}

struct SessionsTabView_Previews: PreviewProvider {
    static var previews: some View {
        SessionsTabView()
    }
}
