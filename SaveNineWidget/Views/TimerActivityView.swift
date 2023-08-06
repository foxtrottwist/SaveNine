//
//  TimerActivityView.swift
//  SaveNineWidgetExtension
//
//  Created by Lawrence Horne on 12/19/22.
//

import SwiftUI
import WidgetKit

struct TimerActivityView: View {
    let context: ActivityViewContext<TimerAttributes>
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(context.attributes.projectName)
                    .font(.headline)
                    
                Spacer()
                Text(context.state.start, style: .timer)
                    .widgetTimer(width: 150)
                    .lineLimit(1)
                    .font(.largeTitle)
            }
            .padding()
            Spacer()
        }
    }
}
