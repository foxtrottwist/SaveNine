//
//  AppIconView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/20/23.
//

import SwiftUI

struct AppIconView: View {
    @AppStorage(StorageKey.selectedAppIcon.rawValue) private var selectedAppIcon: String = AppIcon.defaultIcon.rawValue
    
    var body: some View {
        List {
            ForEach(AppIcon.allCases) { icon in
                HStack {
                    AppIconImageView(icon: icon.rawValue)
                    Text(icon.descriptor)
                    Spacer()
                    
                    if selectedAppIcon == icon.rawValue {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000))
                    }
                }
                .contentShape(Rectangle())
                .navigationTitle("App Icon")
                .onTapGesture {
                    selectedAppIcon = icon.rawValue
                }
            }
        }
        .onChange(of: selectedAppIcon) { handleSelection(appIcon: selectedAppIcon) }
    }
    
    private func handleSelection(appIcon: String) {
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
