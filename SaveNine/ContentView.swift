//
//  ContentView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage(StorageKey.selectedTabView.rawValue) private var selectedTabView: String?
    @State private var tabController = TabController()
    
    var body: some View {
        TabView(selection: $tabController.selectedTabView) {
            ProjectsSplitView(subject: tabController.subject)
                .tag(ProjectsSplitView.tag)
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
            if tabController.selectedTabView != ProjectsSplitView.tag {
                tabController.selectedTabView = ProjectsSplitView.tag
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
