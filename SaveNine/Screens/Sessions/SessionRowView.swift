//
//  SessionRowView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 11/8/22.
//

import SwiftUI

struct SessionRowView: View {
    @ObservedObject var session: Session
    
    @State private var showingSessionDetailView = false
    
    var body: some View {
        Button {
            showingSessionDetailView.toggle()
        } label: {
            VStack(alignment: .leading) {
                Text(session.formattedStartDate)
                    .font(.callout)
                    .foregroundColor(.secondary)
                
                Text(session.formattedDuration)
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingSessionDetailView) {
            SessionDetailView(session: session)
        }
    }
}

struct SessionRowView_Previews: PreviewProvider {
    static var previews: some View {
        SessionRowView(session: Project.example.projectSessions.first!)
    }
}
