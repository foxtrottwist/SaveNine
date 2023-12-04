//
//  GlobalTracker.swift
//  SaveNine
//
//  Created by Lawrence Horne on 12/3/23.
//

import SwiftData
import SwiftUI

struct GlobalTracker: View {
    @State private var offsetY = 100.0
    @Query(filter: Project.predicate(tracking: true)) private var projects: [Project]
    
    var body: some View {
        Color.clear
            .safeAreaInset(edge: .bottom) {
                if projects.isEmpty {
                    Tracker(project: projects.first)
                        .offset(y: offsetY)
                        .task(id: projects) {
                            withAnimation(.easeInOut.delay(0.5)) {
                                offsetY = 100.0
                            }
                        }
                    
                }
                
                if projects.first != nil {
                    Tracker(project: projects.first)
                        .offset(y: offsetY)
                        .task {
                            withAnimation(.bouncy.delay(0.5)) {
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
