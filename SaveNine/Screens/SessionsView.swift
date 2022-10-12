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
    
    @State private var document: TextFile?
    @State var showingSessionsExport = false
    
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
                                Text(formatSession(duration: duration))
                            }
                        }
                    }
                    .onDelete(perform: deleteSession)
                }
                .toolbar {
                    EditButton()
                    
                    Button {
                        showingSessionsExport.toggle()
                        document = TextFile(initialText: export(sessions: sessions))
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                .fileExporter(isPresented: $showingSessionsExport, document: document, contentType: .plainText) { result in
                    switch result {
                    case .success(let success):
                        print(success)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
    }
    
    func export(sessions: [Session]) -> String {
        return sessions.map {
            """
             \($0.startDate!.formatted(date: .abbreviated, time: .shortened))
             \(formatSession(duration: $0.duration))
             
             """
        }
        .reduce("") {
            """
             \($0)
             \($1)
             """
        }
    }
    
    func formatSession(duration: Double) -> String {
        return format(duration: duration, in: .hours) + format(duration: duration, in: .minutes) + format(duration: duration, in: .seconds)
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
