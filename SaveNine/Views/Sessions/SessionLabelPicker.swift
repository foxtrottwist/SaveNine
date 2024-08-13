//
//  SessionLabelPicker.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/9/23.
//

import SwiftData
import SwiftUI

struct SessionLabelPicker: View {
    let disabled: Bool
    @Binding var selectedLabel: String
    @Environment(\.modelContext) private var modelContext
    @State private var name = ""
    @State private var previousSelectedLabel: String
    @State private var showingAddLabelAlert = false
    @Query(sort: \Marker.name, order: .forward) private var markers: [Marker]
   
    init(selectedLabel: Binding<String>, disabled: Bool = false) {
        self.disabled = disabled
        _selectedLabel = selectedLabel
        _previousSelectedLabel = State(wrappedValue: selectedLabel.wrappedValue)
    }
    
    var body: some View {
        Picker("Label", selection: $selectedLabel) {
            ForEach(markers) { marker in
                Text(marker.displayName).tag(marker.displayName)
            }
            
            if !disabled {
                Text(DefaultLabel.none.rawValue).tag(DefaultLabel.none.rawValue)
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
    
    private func addLabel() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let isAllowed = DefaultLabel.allCases.allSatisfy { $0.rawValue.localizedCaseInsensitiveCompare(trimmedName) != ComparisonResult.orderedSame }
        let isUnique = markers.allSatisfy { $0.name?.localizedCaseInsensitiveCompare(trimmedName) != ComparisonResult.orderedSame }
        
        if isAllowed && isUnique {
            modelContext.insert(Marker(name: name))
            previousSelectedLabel = name
            selectedLabel = name
        }
        
        name = ""
    }
    
    private func cancelAction() {
        name = ""
    }
}

#Preview {
    SessionLabelPicker(selectedLabel: .constant("Quilting"))
}

