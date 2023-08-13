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
    let subject: PassthroughSubject<String?, Never>
    @Environment(Navigator.self) private var navigator
    @State private var disabled = false
    
    init(subject: PassthroughSubject<String?, Never> = .init()) {
        self.subject = subject
    }
    
    var body: some View {
        NavigationSplitView {
            AppSidebar(navigator: navigator)
        } detail: {
            if navigator.link == .sessions {
                SessionNavigationStack()
            } else {
                ProjectNavigationStack(navigator: navigator)
                    .onReceive(subject, perform: { tab in
                        if tab == Self.tag, !navigator.path.isEmpty {
                            navigator.path = []
                        }
                    })
            }
        }
    }
    
    static let tag: String? = "Projects"
}

struct ProjectsTabView_Previews: PreviewProvider {
    
    static var previews: some View {
        AppNavigationSplitView(subject: PassthroughSubject<String?, Never>())
            .environment(Navigator())
            .modelContainer(for: [Project.self, Session.self, Tag.self], inMemory: true)
    }
}
