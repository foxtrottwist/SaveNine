//
//  AppNavigationSplitView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import Combine
import CoreData
import SwiftUI

struct AppNavigationSplitView: View {
    private let navigator = Navigator.shared
    @State private var disabled = false
    
    var body: some View {
        NavigationSplitView {
            AppSidebar(navigator: navigator)
        } detail: {
            if navigator.selection == .sessions {
                SessionNavigationStack()
            } else {
                ProjectNavigationStack(navigator: navigator)
                    .onReceive(navigator.subject, perform: { tab in
                        if tab == Self.tag, !navigator.path.isEmpty {
                            navigator.path = []
                        }
                    })
            }
        }
    }
    
    static let tag: String? = "Projects"
}

#Preview {
    AppNavigationSplitView()
        .modelContainer(for: [Project.self, Session.self, Tag.self], inMemory: true)
}
