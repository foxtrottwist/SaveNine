//
//  ContentView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.prefersTabNavigation) private var prefersTabNavigation
    
    var body: some View {
        Group {
            if prefersTabNavigation {
                AppTabView()
            } else {
                AppNavigationSplitView()
            }
        }
    }
}

#Preview {
    ContentView()
}
