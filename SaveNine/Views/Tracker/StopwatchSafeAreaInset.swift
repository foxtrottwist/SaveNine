//
//  StopwatchSafeAreaInset.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/31/23.
//

import SwiftUI

struct StopwatchSafeAreaInset: View {
    let start: Date?
    let tracking: Bool
    let startAction: () -> Void
    let stopAction: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.ultraThickMaterial)
            
            HStack {
                TimerView(start: start)
                    .font(.title)
                
                Spacer()
                
                if tracking {
                    Button(action: {}) {
                        Label("Stop", systemImage: "stop.fill")
                    }
                } else {
                    Button(action: {}) {
                        Label("Start", systemImage: "play.fill")
                    }
                }
            }
            .padding()
        }
        .frame(height: 70)
        .padding()
        .shadow(color: .secondary, radius: 10, x: 0, y: 15)
    }
}

#Preview {
    StopwatchSafeAreaInset(start: .now, tracking: true, startAction: {}, stopAction: {})
}
