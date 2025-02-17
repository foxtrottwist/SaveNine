//
//  SessionRow.swift
//  SaveNine
//
//  Created by Lawrence Horne on 11/8/22.
//

import SwiftUI

struct SessionRow: View {
    var session: Session
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
                        Text(session.displayLabel)
                            .font(.callout)
                            .foregroundColor(session.displayLabel == DefaultLabel.none.rawValue ? .clear : nil)
                        
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
            SessionDetail(session: session)
        }
    }
}

struct SessionRowView_Previews: PreviewProvider {
    static var previews: some View {
        SessionRow(session: Session.preview)
    }
}
