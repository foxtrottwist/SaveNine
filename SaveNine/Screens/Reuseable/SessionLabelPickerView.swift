//
//  SessionLabelPickerView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/9/23.
//

import SwiftUI

struct SessionLabelPickerView: View {
    let sessionLabels: [SessionLabel]
    
    @State var selectedLabel: String = ""
    
    var body: some View {
        if sessionLabels.isEmpty {
            Button("Add Label") {}
        } else {
            Picker("Labels", selection: $selectedLabel) {
                ForEach(sessionLabels) { sessionLabel in
                    Text(sessionLabel.name).tag(sessionLabel.name)
                }
            }
        }
    }
}

struct SessionLabelPickerView_Previews: PreviewProvider {
    static var previews: some View {
        SessionLabelPickerView(sessionLabels: SessionLabel.Examples)
    }
}
