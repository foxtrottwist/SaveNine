//
//  TagView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 10/7/22.
//

import SwiftUI

struct TagView: View {
    let name: String
    let color: Color
    
    var body: some View {
        VStack {
            Text(name)
        }
        .padding(10)
        .background(Color(.clear))
        .clipShape(Capsule(style: .continuous))
        .overlay {
            Capsule(style: .continuous)
                .stroke(color, lineWidth: 2)
        }
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(name: "fpp", color: Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000))
    }
}
