//
//  SessionLabelPickerView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/9/23.
//

import SwiftUI

struct SessionLabelPickerView: View {
    @EnvironmentObject var sessionLabels: SessionLabels
    
    @Binding var selectedLabel: String
    
    @State private var name = ""
    @State private var previousSelectedLabel = Defaults.none.rawValue
    @State private var showingAddLabelAlert = false
    
    init(selectedLabel: Binding<String>) {
        _selectedLabel = selectedLabel
        _previousSelectedLabel = State(wrappedValue: selectedLabel.wrappedValue)
    }
    
    enum Defaults: String {
        case addLabel = "Add Label"; case none = "None"
    }
    
    var body: some View {
        Picker("Label", selection: $selectedLabel) {
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
        if name.trimmingCharacters(in: .whitespaces).isEmpty
            || name.lowercased().trimmingCharacters(in: .whitespaces) == Defaults.addLabel.rawValue.lowercased()
            || name.lowercased().trimmingCharacters(in: .whitespaces) == Defaults.none.rawValue.lowercased() {
            name = ""
            return
        }
            
        sessionLabels.objectWillChange.send()
        
        let label = SessionLabel(id: UUID(), name: name, lastUsed: Date())
        sessionLabels.add(label: label)
        previousSelectedLabel = name
        selectedLabel = name
        name = ""
        sessionLabels.save()
            
    }
    
    func cancelAction() {
        name = ""
    }
}

struct SessionLabelPickerView_Previews: PreviewProvider {
    static var previews: some View {
        SessionLabelPickerView(selectedLabel: .constant(""))
            .environmentObject(SessionLabels())
    }
}
