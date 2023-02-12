//
//  SessionLabelPickerView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/9/23.
//

import SwiftUI

struct SessionLabelPickerView: View {
    @EnvironmentObject var sessionLabels: SessionLabels
    
    @State private var name = ""
    @State private var previousSelectedLabel = Defaults.none.rawValue
    @State private var selectedLabel = Defaults.none.rawValue
    @State private var showingAddLabelAlert = false
    
    init(selectedLabel: String) {
        _selectedLabel = State(wrappedValue: selectedLabel)
        _previousSelectedLabel = State(wrappedValue: selectedLabel)
    }
    
    enum Defaults: String {
        case addLabel = "Add Label"; case none = "None"
    }
    
    var body: some View {
        Picker("Labels", selection: $selectedLabel) {
            ForEach(sessionLabels.labels) { sessionLabel in
                Text(sessionLabel.name).tag(sessionLabel.name)
            }
           
            Text(Defaults.none.rawValue).tag(Defaults.none.rawValue)
            Text(Defaults.addLabel.rawValue).tag(Defaults.addLabel.rawValue)
        }
        .alert(Defaults.addLabel.rawValue, isPresented: $showingAddLabelAlert) {
            UpdateNameView(name: $name, cancelAction: cancelAction, confirmAction: addLabel)
        }
        .onChange(of: selectedLabel) { label in
            if label == Defaults.addLabel.rawValue {
                showingAddLabelAlert = true
                selectedLabel = ""
            }
        }
    }
    
    func addLabel() {
        if name.isEmpty
        || name.lowercased().contains(Defaults.addLabel.rawValue.lowercased())
        || name.lowercased().contains(Defaults.none.rawValue.lowercased()) {
            name = ""
            return
        }
            
        sessionLabels.objectWillChange.send()
        
        let label = SessionLabel(id: UUID(), name: name, lastUsed: Date())
        sessionLabels.add(label: label)
        previousSelectedLabel = name
        selectedLabel = name
        name = ""
//        sessionLabels.save()
            
    }
    
    func cancelAction() {
        name = ""
    }
}

struct SessionLabelPickerView_Previews: PreviewProvider {
    static var previews: some View {
        SessionLabelPickerView(selectedLabel: "")
            .environmentObject(SessionLabels())
    }
}
