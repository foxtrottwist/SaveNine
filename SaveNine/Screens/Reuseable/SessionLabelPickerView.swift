//
//  SessionLabelPickerView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/9/23.
//

import SwiftUI

struct SessionLabelPickerView: View {
    
    
    @State private var name = ""
    @State private var selectedLabel = ""
    @State private var sessionLabels: [SessionLabel]
    @State private var showingAddLabelAlert = false
    
    init(selectedLabel: String, sessionLabels: [SessionLabel]) {
        self.sessionLabels = sessionLabels
        
       _selectedLabel = State(wrappedValue: selectedLabel)
    }
    
    var body: some View {
        if sessionLabels.isEmpty {
            HStack {
                Text("Optional –")
                    .italic()
                    .font(.callout)
                    .foregroundColor(.secondary)
                
                Button("Add Label") {
                    showingAddLabelAlert = true
                }
            }
            .alert("Add Label", isPresented: $showingAddLabelAlert) {
                UpdateNameView(name: $name, cancelAction: {}, confirmAction: {})
            }
        } else {
            Picker("Labels", selection: $selectedLabel) {
                ForEach(sessionLabels) { sessionLabel in
                    Text(sessionLabel.name).tag(sessionLabel.name)
                }
            }
        }
    }
    
    func addLabel() {
        if name.isEmpty {
        } else {
            let sessionLabel = [SessionLabel(id: UUID(), name: name, lastUsed: Date())]
            
            let encoder = JSONEncoder()
            let _ = try? encoder.encode(sessionLabel)
            
            sessionLabels = sessionLabel
        }
    }
}

struct SessionLabelPickerView_Previews: PreviewProvider {
    static var previews: some View {
        SessionLabelPickerView(selectedLabel: "", sessionLabels: [])
    }
}
