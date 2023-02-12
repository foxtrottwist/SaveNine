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
    @State private var previousSelectedLabel: String
    @State private var showingAddLabelAlert = false
    
    init(selectedLabel: Binding<String>) {
        _selectedLabel = selectedLabel
        _previousSelectedLabel = State(wrappedValue: selectedLabel.wrappedValue)
    }
    
    var body: some View {
        Picker("Label", selection: $selectedLabel) {
            ForEach(sessionLabels.labels) { sessionLabel in
                Text(sessionLabel.name).tag(sessionLabel.name)
            }
            
            Divider()
            Text(DefaultLabel.none.rawValue).tag(DefaultLabel.none.rawValue)
            Text(DefaultLabel.addLabel.rawValue).tag(DefaultLabel.addLabel.rawValue)
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
        sessionLabels.add(name: name)
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
            .environmentObject(SessionLabels())
    }
}
