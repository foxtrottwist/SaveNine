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
    @Environment(Navigator.self) private var navigation
    @State private var disabled = false
    @State private var path: [Project] = []
    
    init(subject: PassthroughSubject<String?, Never> = .init()) {
        self.subject = subject
    }
    
    var body: some View {
        NavigationSplitView {
            AppSidebar(navigation: navigation)
        } detail: {
            if navigation.filter == .sessions {
                SessionNavigationStack()
            } else {
                ProjectNavigationStack(path: $path)
                    .onReceive(subject, perform: { tab in
                        if tab == Self.tag, !path.isEmpty {
                            path = []
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
