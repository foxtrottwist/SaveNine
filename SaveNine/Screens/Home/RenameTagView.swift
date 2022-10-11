//
//  RenameTagView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 10/8/22.
//

import SwiftUI

struct RenameTagView: View {
    let renameAction: () -> Void
    let cancelAction: () -> Void
    
    @Binding var name: String
    
    init(name: Binding<String>, renameAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
        _name = name
        
        self.renameAction = renameAction
        self.cancelAction = cancelAction
    }
    
    var body: some View {
        TextField("Tag Name", text: $name)
            .autocapitalization(.none)
            .autocorrectionDisabled(true)
        
        Button("Cancel", role: .cancel) {
            cancelAction()
        }
        
        Button("OK") {
           renameAction()
        }
    }
}

struct RenameTagVieww_Previews: PreviewProvider {
    static var previews: some View {
        RenameTagView(name: .constant("quilting"), renameAction: {}, cancelAction: {})
    }
}
