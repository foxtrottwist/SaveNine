//
//  SaveNineApp.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import SwiftUI

@main
struct SaveNineApp: App {
    @StateObject var dataController: DataController
    @StateObject var sessionLabels: SessionLabels
        
        init() {
            let dataController = DataController()
            _dataController = StateObject(wrappedValue: dataController)
            
            let sessionLabel = SessionLabels()
            _sessionLabels = StateObject(wrappedValue: sessionLabel)
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(sessionLabels)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: save)
        }
    }
    
    func save(_ note: Notification) {
        dataController.save()
    }
}
