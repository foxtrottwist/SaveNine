//
//  ContentView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import SwiftUI

struct ContentView: View {
    private var navigation = Navigator()
    @Environment(\.prefersTabNavigation) private var prefersTabNavigation
    
    var body: some View {
        Group {
            if prefersTabNavigation {
                AppTabView()
            } else {
                AppNavigationSplitView()
            }
        }
        .environment(navigation)
    }
}

#Preview {
    ContentView()
}
