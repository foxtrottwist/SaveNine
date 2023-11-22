//
//  SessionLabelPicker.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/9/23.
//

import SwiftUI

struct SessionLabelPicker: View {
    let disableAddLabel: Bool
    @Binding var selectedLabel: String
    @Environment(SessionLabelController.self) var sessionLabelController
    @State private var name = ""
    @State private var previousSelectedLabel: String
    @State private var showingAddLabelAlert = false
   // Temporarily disabled adding labels; disabledAddLabel default set to true.
    init(selectedLabel: Binding<String>, disableAddLabel: Bool = true) {
        self.disableAddLabel = disableAddLabel
        _selectedLabel = selectedLabel
        _previousSelectedLabel = State(wrappedValue: selectedLabel.wrappedValue)
    }
    
    var body: some View {
        Picker("Label", selection: $selectedLabel) {
            ForEach(sessionLabelController.labels) { sessionLabel in
                Text(sessionLabel.name).tag(sessionLabel.name)
            }
            
            Text(DefaultLabel.none.rawValue).tag(DefaultLabel.none.rawValue)
            
            if !disableAddLabel {
                Divider()
                Text(DefaultLabel.addLabel.rawValue).tag(DefaultLabel.addLabel.rawValue)
            }
        }
        .alert(DefaultLabel.addLabel.rawValue, isPresented: $showingAddLabelAlert) {
            UpdateNameView(name: $name, cancelAction: cancelAction, confirmAction: addLabel)
        }
        .onChange(of: selectedLabel) { 
            if selectedLabel == DefaultLabel.addLabel.rawValue {
                showingAddLabelAlert = true
                selectedLabel = previousSelectedLabel
            }
        }
    }
    
    func addLabel() {
        sessionLabelController.add(name: name)
        previousSelectedLabel = name
        selectedLabel = name
        name = ""
    }
    
    func cancelAction() {
        name = ""
    }
}

struct SessionLabelPickerView_Previews: PreviewProvider {
    static var previews: some View {
        SessionLabelPicker(selectedLabel: .constant("None"))
            .environment(SessionLabelController.preview)
    }
}
