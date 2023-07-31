//
//  ContentView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import SwiftUI

struct ContentView: View {
    private var navigation = Navigation()
    @Environment(\.prefersTabNavigation) private var prefersTabNavigation
    
    var body: some View {
        Group {
            if prefersTabNavigation {
                AppTabView()
            } else {
                ProjectsSplitView()
            }
        }
        .environment(navigation)
    }
}

#Preview {
    ContentView()
}
