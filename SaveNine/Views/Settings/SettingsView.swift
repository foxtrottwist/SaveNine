//
//  SettingsView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/19/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dataController: DataController
    @EnvironmentObject private var sessionLabelController: SessionLabelController
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("App Icon", destination: AppIconView())
                    NavigationLink("Labels", destination: LabelsView())
                } header: {
                    Text("Customization")
                }
                
                Section {
                    NavigationLink("About", destination: AboutView())
                    Link("Save Nine Website", destination: URL(string: "https://www.apple.com")!)
                } header: {
                    Text("Support")
                }
                
                Section {
                    Button {
                        
                    } label: {
                        Label("Erase All Data", systemImage: "hand.raised")
                            .foregroundColor(.red)
                    }
                } header: {
                    Text("Danger Zone")
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
