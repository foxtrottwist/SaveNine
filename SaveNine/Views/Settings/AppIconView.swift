//
//  AppIconView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/20/23.
//

import SwiftUI

struct AppIconView: View {
    @AppStorage("selectedAppIcon") private var selectedAppIcon: String = "AppIcon"
    
    var body: some View {
        Picker("App Icon", selection: $selectedAppIcon) {
            Text("Default Icon").tag("AppIcon")
            Text("Pawpaw Pink").tag("AppIcon-2")
        }
        .onChange(of: selectedAppIcon, perform: handleSelectedAppIcon)
    }
    
    private func handleSelectedAppIcon(appIcon: String) {
        if UIApplication.shared.supportsAlternateIcons {
            if appIcon == "AppIcon" {
                UIApplication.shared.setAlternateIconName(nil)
            } else {
                UIApplication.shared.setAlternateIconName(selectedAppIcon) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

struct AppIconView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconView()
    }
}
