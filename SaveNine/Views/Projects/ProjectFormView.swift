//
//  ProjectFormView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/14/23.
//

import SwiftUI

struct ProjectFormView: View {
    let editing: Bool
    
    @Binding var name: String
    @Binding var detail: String
    @Binding var tags: String
    
    
    var body: some View {
        Form {
            if editing {
                Text("Project Name")
                    .font(.callout)
                    .fontWeight(.light)
                    .italic()
                
                TextField("Project Name", text: $name)
                    .padding(.bottom)
            }
                      
            Text("Notes")
                .font(.callout)
                .fontWeight(.light)
                .italic()
            
            TextField("Notes", text: $detail, axis: .vertical)
                .padding(.bottom)
            
            Text("Tags")
                .font(.callout)
                .fontWeight(.light)
                .italic()
            
            TextField("Text, separated by spaces", text: $tags)
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
                .foregroundColor(Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000))
        }
        .disabled(!editing)
        .animation(.easeIn, value: editing)
        .formStyle(.columns)
        .padding()
    }
}

struct ProjectFormView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectFormView(editing: false, name: .constant(""), detail: .constant(""), tags: .constant(""))
    }
}
