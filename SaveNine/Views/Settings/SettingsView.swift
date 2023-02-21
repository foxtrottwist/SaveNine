//
//  SettingsView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/19/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("App Icon", destination: AppIconView())
                    NavigationLink("Labels", destination: LabelsView())
                }
                
                Section {
                    NavigationLink("About", destination: AboutView())
                    
                    Link(destination: URL(string: "https://www.apple.com")!) {
                        HStack {
                            Text("Homepage")
                                .foregroundColor(.primary)
                            Spacer()
                            Text("savenine.app")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack {
                        Text("Email")
                        Spacer()
                        Text("support@savenine.app")
                            .foregroundColor(.secondary)
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
