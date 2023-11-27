//
//  ScrollingText.swift
//  SaveNine
//
//  Created by Lawrence Horne on 11/27/23.
//

import SwiftUI

struct ViewSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct ViewGeometry: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: ViewSizeKey.self, value: geometry.size)
        }
    }
}

struct ScrollingText: View {
    private var text: String
    @State private var animate: Bool = false
    @State private var offsetX: Double = 0.0
    @State private var textSize: CGSize = .zero
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width * 0.25
            let positionX = geometry.size.width / 2 + (width / 2) / 2
            let positionY = geometry.size.height / 2
            
            HStack {
                Group {
                    if animate {
                        Text(text)
                            .offset(x: offsetX)
                            .task(id: textSize) {
                                withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                                    offsetX = -(width + (textSize.width - width))
                                }
                            }
                    } else {
                        Text(text)
                    }
                    
                }
                .fixedSize() // Prevents text truncation.
                .background(ViewGeometry()) // Monitor View size using PreferenceKey.
                .onPreferenceChange(ViewSizeKey.self) {
                    textSize = $0
                    animate = textSize.width > width
                    
                    if animate {
                        offsetX = width + (textSize.width - width)
                    } else {
                        offsetX = 0.0
                    }
                }
            }
            .frame(width: width)
            .clipped() // Obscures text when scrolling.
            .position(x: positionX, y: positionY)
        }
    }
}


#Preview {
    ScrollingText("This is a long bit of text!")
}
