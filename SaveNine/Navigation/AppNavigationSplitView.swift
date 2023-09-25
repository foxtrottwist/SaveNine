//
//  AppNavigationSplitView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import Combine
import SwiftUI

struct AppNavigationSplitView: View {
    @State private var selection: Screen? = .open
    
    var body: some View {
        NavigationSplitView {
            AppSidebar(selection: $selection)
        } detail: {
            selection?.destination
                .onReceive(Navigator.shared.subject, perform: { tab in
                    if tab == Self.tag, !Navigator.shared.path.isEmpty {
                        Navigator.shared.path = []
                    }
                })
        }
    }
    
    static let tag: String? = "Projects"
}

#Preview {
    AppNavigationSplitView()
        .modelContainer(for: [Project.self, Session.self, Tag.self], inMemory: true)
}
