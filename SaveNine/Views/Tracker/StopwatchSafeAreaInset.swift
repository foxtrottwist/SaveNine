//
//  StopwatchSafeAreaInset.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/31/23.
//

import SwiftUI

struct StopwatchSafeAreaInset: View {
    let label: String
    let start: Date?
    let tracking: Bool
    let startAction: () -> Void
    let stopAction: () -> Void
    let onTapGesture: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.ultraThickMaterial)
            
            ScrollingText(label)
                .font(.subheadline)
            
            HStack {
                HStack {
                    TimerTimelineView(start: start)
                        .font(.title)
                    Spacer()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    onTapGesture()
                }
                
                if tracking {
                    Button {
                           stopAction()
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
    StopwatchSafeAreaInset(
        label: "Design",
        start: .now,
        tracking: true,
        startAction: {},
        stopAction: {},
        onTapGesture: {}
    )
}
