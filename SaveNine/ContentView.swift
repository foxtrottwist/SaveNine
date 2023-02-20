//
//  ContentView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") private var selectedView: String?
    @StateObject private var tabController = TabController()
    
    var body: some View {
        TabView(selection: $tabController.selectedView) {
            ProjectsTabView(subject: tabController.subject)
                .tag(ProjectsTabView.tag)
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
        .onAppear(perform: { tabController.selectedView = selectedView })
        .onChange(of: tabController.selectedView) { _ in selectedView = tabController.selectedView }
        .onOpenURL { _ in tabController.selectedView = ProjectsTabView.tag }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
