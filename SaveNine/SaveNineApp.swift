//
//  SaveNineApp.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import SwiftUI

@main
struct SaveNineApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(Persistence.container)
        }
    }
}
