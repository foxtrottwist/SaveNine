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
        List {
            ForEach(AppIcon.allCases, id: \.rawValue) { icon in
                HStack {
                    Image(uiImage: UIImage(named: icon.rawValue) ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 25, height: 25)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Text(icon.descriptor)
                    Spacer()
                    
                    if selectedAppIcon == icon.rawValue {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000))
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedAppIcon = icon.rawValue
                }
            }
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
