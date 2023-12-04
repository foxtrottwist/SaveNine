//
//  Screen.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/20/23.
//

import Foundation
import SwiftUI

enum Screen: Codable, Hashable, Identifiable, CaseIterable {
    case all
    case open
    case closed
    case sessions
    case tag(name: String, id: UUID)
    
    var id: Screen { self }
    
    static var allCases: [Screen] {
        [.all, .open, .closed, .sessions]
    }
    
    static var prefersTabNavigationCases: [Screen] {
        [.all, .open, .closed]
    }
}

extension Screen {
    @ViewBuilder
    var label: some View {
        switch self {
        case .all:
            Label("All Projects", systemImage: "tray.full")
        case .open:
            Label("Open Projects", systemImage: "tray")
        case .closed:
            Label("Closed Projects", systemImage: "archivebox")
        case .sessions:
            Label("Sessions", systemImage: "clock")
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .all, .open, .closed:
            ProjectNavigationStack(screen: self)
        case .sessions:
            SessionNavigationStack()
        case  .tag:
            TagNavigationStack(screen: self)
        }
    }
    
    var title: String {
        switch self {
        case .all:
            "All"
        case .open:
            "Open"
        case .closed:
            "Closed"
        case .sessions:
            "Sessions"
        case .tag(let name, _):
            name
        }
    }
}
