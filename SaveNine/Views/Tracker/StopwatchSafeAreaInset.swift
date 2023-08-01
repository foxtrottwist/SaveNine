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
    let stopAction: () async -> Void
    let onTap: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.ultraThickMaterial)
            
            HStack {
                HStack {
                    TimerTimelineView(start: start)
                        .font(.title)
                    Spacer()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    onTap()
                }
                
                
                if tracking {
                    Button {
                        Task {
                           await stopAction()
                        }
                    } label: {
                        Label("Stop", systemImage: "stop.fill")
                    }
                } else {
                    Button(action: startAction) {
                        Label("Start", systemImage: "play.fill")
                    }
                }
            }
            .padding()
        }
        .frame(height: 70)
        .padding()
        .shadow(color: colorScheme == .light ? .secondary : .clear, radius: 10, x: 0, y: 15)
    }
}

#Preview {
    StopwatchSafeAreaInset(start: .now, tracking: true, startAction: {}, stopAction: {}, onTap: {})
}
