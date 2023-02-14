//
//  ContentView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    
    var body: some View {
        TabView(selection: $selectedView) {
            ProjectsView()
                .tag(ProjectsView.tag)
                .tabItem {
                    Image(systemName: "tray")
                    Text("Projects")
                }
            
            
            SessionsTabView()
                .tag(SessionsTabView.tag)
                .tabItem {
                    Image(systemName: "clock")
                    Text("Sessions")
                }
        }
        .onOpenURL { _ in
            selectedView = ProjectsView.tag
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
