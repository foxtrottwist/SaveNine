//
//  UpdateNameView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 10/8/22.
//

import SwiftUI

struct UpdateNameView: View {
    let cancelAction: () -> Void
    let confirmAction: () -> Void
    
    @Binding var name: String
    
    init(name: Binding<String>, cancelAction: @escaping () -> Void, confirmAction: @escaping () -> Void) {
        _name = name
        
        self.cancelAction = cancelAction
        self.confirmAction = confirmAction
    }
    
    var body: some View {
        TextField("Name", text: $name)
            .autocapitalization(.none)
            .autocorrectionDisabled(true)
        
        Button("Cancel", role: .cancel) {
            cancelAction()
        }
        
        Button("OK") {
           confirmAction()
        }
    }
}

struct UpdateNameView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateNameView(name: .constant("quilting"),  cancelAction: {}, confirmAction: {})
    }
}
