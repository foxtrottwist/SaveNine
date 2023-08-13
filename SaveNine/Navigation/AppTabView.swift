//
//  AppTabView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/30/23.
//

import SwiftUI

struct AppTabView: View {
    @Bindable var navigator: Navigator
    @SceneStorage(StorageKey.selectedTabView.rawValue) private var selectedTab: String?
    
    var body: some View {
        TabView(selection: $navigator.selectedTab) {
            Group {
                AppNavigationSplitView()
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
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        }
        .onAppear(perform: { navigator.selectedTab = selectedTab })
        .onChange(of: navigator.selectedTab) {  selectedTab = navigator.selectedTab }
        .onOpenURL { _ in
            if navigator.selectedTab != AppNavigationSplitView.tag {
                navigator.selectedTab = AppNavigationSplitView.tag
            }
        }
    }
}

#Preview {
    AppTabView(navigator: Navigator())
}
