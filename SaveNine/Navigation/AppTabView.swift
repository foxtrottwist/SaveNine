//
//  AppTabView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/30/23.
//

import SwiftUI

struct AppTabView: View {
    @SceneStorage(StorageKey.selectedTabView.rawValue) private var selectedTabView: String?
    @State private var tabController = TabController()
    
    var body: some View {
        TabView(selection: $tabController.selectedTabView) {
            AppNavigationSplitView(subject: tabController.subject)
                .tag(AppNavigationSplitView.tag)
                .tabItem {
                    Image(systemName: "tray")
                    Text(AppNavigationSplitView.tag!)
                }
            
            SessionNavigationStack()
                .tag(SessionNavigationStack.tag)
                .tabItem {
                    Image(systemName: "clock")
                    Text(SessionNavigationStack.tag!)
                }
        }
        .onAppear(perform: { tabController.selectedTabView = selectedTabView })
        .onChange(of: tabController.selectedTabView) {  selectedTabView = tabController.selectedTabView }
        .onOpenURL { _ in
            if tabController.selectedTabView != AppNavigationSplitView.tag {
                tabController.selectedTabView = AppNavigationSplitView.tag
            }
        }
    }
}

#Preview {
    AppTabView()
}
