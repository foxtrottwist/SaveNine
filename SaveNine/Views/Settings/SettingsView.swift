//
//  SettingsView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/19/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(StorageKey.selectedAppIcon.rawValue) private var selectedAppIcon: String = "AppIcon"
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: AppIconView()) {
                        HStack {
                            Text("App Icon")
                            Spacer()
                            AppIconImageView(icon: selectedAppIcon)
                        }
                    }
                    
                    NavigationLink("Labels", destination: LabelsView())
                }
                
                Section {
//                    Link(destination: URL(string: "https://www.savenine.app")!) {
                        HStack {
                            Text("Homepage")
                                .foregroundColor(.primary)
                            Spacer()
                            Text("savenine.app")
                                .foregroundColor(.secondary)
//                        }
                    }
                    
                    HStack {
                        Text("Email")
                        Spacer()
                        Text("support@savenine.app")
                            .tint(.secondary)
                    }
                } header: {
                    Text("Support")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Close") {
                    dismiss()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
