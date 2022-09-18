//
//  DigitView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/18/22.
//

import SwiftUI

struct DigitView: View {
    let digit: String
    
    var body: some View {
        Canvas { context, size in
            context.withCGContext { _ in
                let midPoint = CGPoint(x: size.width/2.0, y: size.height/2.0)
                
                let text = Text(digit)
                    .font(.largeTitle)
                
                context.blendMode = GraphicsContext.BlendMode.softLight
                context.draw(text, at: midPoint)
            }
        }
        .frame(width: 20)
    }
}

struct DigitsView_Previews: PreviewProvider {
    static var previews: some View {
        DigitView(digit: "00")
    }
}
