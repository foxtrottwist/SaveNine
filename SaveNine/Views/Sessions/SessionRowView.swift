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
    
    var day: String {
        (session.startDate?.relativeDescription(hourMinute: false)) ?? ""
    }
    
    var startTime: String {
        session.startDate?.hourMinute ?? ""
    }
    
    var endTime: String {
        session.endDate?.hourMinute ?? ""
    }
    
    var sessionDateDescription: some View {
        Text("\(day) \(startTime) - \(endTime)")
            .font(.callout)
            .foregroundColor(.secondary)
            .italic()
    }
    
    var body: some View {
        Button {
            showingSessionDetailView.toggle()
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    sessionDateDescription
                    
                    HStack {
                        Text(session.sessionLabel)
                            .font(.callout)
                            .foregroundColor(session.sessionLabel == DefaultLabel.none.rawValue ? .clear : nil)
                        
                        Spacer()
                        Text(session.formattedDuration)
                            .font(.title2)
                    }
                }
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingSessionDetailView) {
            SessionDetailView(session: session)
        }
    }
}

struct SessionRowView_Previews: PreviewProvider {
    static var previews: some View {
        SessionRowView(session: Session.Example)
    }
}
