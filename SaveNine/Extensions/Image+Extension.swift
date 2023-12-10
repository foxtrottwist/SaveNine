//
//  Image+Extension.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/29/23.
//

import SwiftUI

extension Image {
    func projectImage(width: CGFloat = 200, height: CGFloat = 200, cornerRadius: CGFloat = 15) -> some View {
        self
            .resizable()
            .scaledToFill()
            .frame(width: width, height: width)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
