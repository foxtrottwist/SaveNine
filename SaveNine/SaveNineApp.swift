//
//  SaveNineApp.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import SwiftUI

@main
struct SaveNineApp: App {
    var sessionLabelController = SessionLabelController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(sessionLabelController)
                .modelContainer(Persistence.container)
        }
    }
}
