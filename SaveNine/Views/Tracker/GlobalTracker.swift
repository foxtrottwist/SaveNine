//
//  GlobalTracker.swift
//  SaveNine
//
//  Created by Lawrence Horne on 12/3/23.
//

import SwiftData
import SwiftUI

struct GlobalTracker: View {
    @State private var project: Project?
    @State private var offsetY = 200.0
    @Query(filter: Project.predicate(tracking: true)) private var projects: [Project]
    
    var body: some View {
        Color.clear
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Image(systemName: "stopwatch")
                        .padding()
                }
                .background(.accent)
                .clipShape(Circle())
                .padding()
                .offset(y: offsetY)
                .task(id: projects) {
                    if projects.isEmpty {
                        defer { project = nil }
                        withAnimation(.easeInOut.delay(0.5)) {
                            offsetY = 200.0
                        }
                    }
                    
                    if projects.first != nil {
                        defer { project = projects.first }
                        withAnimation(.bouncy.delay(0.4)) {
                            offsetY = 0.0
                        }
                    }
                }
            }
    }
}

#Preview {
    GlobalTracker()
}
