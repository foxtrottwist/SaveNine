//
//  TimerView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/18/22.
//

import SwiftUI

struct TimerView: View {
    let start: Date?
    
    var body: some View {
        if let start = start {
            TimelineView(.periodic(from: start, by: 1)) { _ in
                let hours = digitsFrom(string: elapsedTime(since: start, in: .hours))
                let minutes = digitsFrom(string: elapsedTime(since: start, in: .minutes))
                let seconds = digitsFrom(string: elapsedTime(since: start, in: .seconds))
                
                HStack {
                    DigitView(digit: hours.0)
                    DigitView(digit: hours.1)
                    Text(":")
                    DigitView(digit: minutes.0)
                    DigitView(digit: minutes.1)
                    Text(":")
                    DigitView(digit: seconds.0)
                    DigitView(digit: seconds.1)
                }
                .font(.largeTitle)
                .padding()
            }
        } else {
            HStack {
                DigitView(digit: "0")
                DigitView(digit: "0")
                Text(":")
                DigitView(digit: "0")
                DigitView(digit: "0")
                Text(":")
                DigitView(digit: "0")
                DigitView(digit: "0")
            }
            .font(.largeTitle)
            .padding()
        }
    }
    
    func digitsFrom(string: String) -> (String, String) {
        let split = string.split(separator: "")

        return (String(split.first ?? "0"), String(split.last ?? "0"))
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(start: Date())
    }
}
