//
//  ContentView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage(StorageKey.selectedTabView.rawValue) private var selectedTabView: String?
    @StateObject private var tabController = TabController()
    
    var body: some View {
        TabView(selection: $tabController.selectedTabView) {
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
        .onAppear(perform: { tabController.selectedTabView = selectedTabView })
        .onChange(of: tabController.selectedTabView) {  selectedTabView = tabController.selectedTabView }
        .onOpenURL { _ in
            if tabController.selectedTabView != ProjectsTabView.tag {
                tabController.selectedTabView = ProjectsTabView.tag
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
