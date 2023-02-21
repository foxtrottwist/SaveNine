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
    @State private var showingDeleteAllDataConfirmation = false
    
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
                        showingDeleteAllDataConfirmation.toggle()
                    } label: {
                        Label("Erase All Data", systemImage: "hand.raised")
                            .foregroundColor(.red)
                    }
                } header: {
                    Text("Danger Zone")
                }
            }
            .confirmationDialog(
                "Are you sure you want to erase all date? This cannot be undone.",
                isPresented: $showingDeleteAllDataConfirmation,
                titleVisibility: .visible
            ) {
                Button("Erase All Data", role: .destructive, action: deleteAllData)
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
    
    private func deleteAllData() {
//        dataController.deleteAll()
        FileManager.deleteDocumentsDirectoryContents()
        FileManager.deleteAppGroupContainerContents()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
