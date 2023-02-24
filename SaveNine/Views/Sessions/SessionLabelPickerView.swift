//
//  SessionLabelPickerView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/9/23.
//

import SwiftUI

struct SessionLabelPickerView: View {
    let disableAddLabel: Bool
    
    @EnvironmentObject var sessionLabelController: SessionLabelController
    
    @Binding var selectedLabel: String
    
    @State private var name = ""
    @State private var previousSelectedLabel: String
    @State private var showingAddLabelAlert = false
    
    init(selectedLabel: Binding<String>, disableAddLabel: Bool = false) {
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
        .onChange(of: selectedLabel) { label in
            if label == DefaultLabel.addLabel.rawValue {
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
        SessionLabelPickerView(selectedLabel: .constant("None"))
            .environmentObject(SessionLabelController.preview)
    }
}
