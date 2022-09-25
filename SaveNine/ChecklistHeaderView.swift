//
//  ChecklistHeaderView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/25/22.
//

import SwiftUI

struct ChecklistHeaderView: View {
    let checklist: Checklist
    
    @State var name: String
        
    init(checklist: Checklist) {
        self.checklist = checklist
            
        _name = State(wrappedValue: checklist.checklistName)
        }
        
    var body: some View {
        TextField("List Name", text: $name)
            .font(.title3)
            .foregroundColor(.blue)
            .padding(.top)
            .onChange(of: name, perform: { name in checklist.name = name })
            
        Divider()
    }
}

struct ChecklistHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistHeaderView(checklist: Checklist.example)
    }
}
