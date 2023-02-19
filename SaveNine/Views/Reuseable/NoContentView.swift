//
//  NoContentView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 10/15/22.
//

import SwiftUI

struct NoContentView: View {
    let message: String
    
    var body: some View {
        VStack {
            Text(message)
                .italic()
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

struct NoContentView_Previews: PreviewProvider {
    static var previews: some View {
        NoContentView(message: "Nothing to see here. Select something to see some content.")
    }
}
