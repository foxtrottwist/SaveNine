//
//  WidgetTimer-Modifier.swift
//  SaveNineWidgetExtension
//
//  Created by Lawrence Horne on 12/30/22.
//

import SwiftUI

struct WidgetTimer: ViewModifier {
    let width: CGFloat
    
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.trailing)
            .frame(width: width)
            .monospacedDigit()
    }
}

extension View {
    func widgetTimer(width: CGFloat) -> some View {
       modifier(WidgetTimer(width: width))
    }
}
