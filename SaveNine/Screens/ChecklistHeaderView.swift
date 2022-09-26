//
//  ChecklistHeaderView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/25/22.
//

import SwiftUI

struct ChecklistHeaderView: View {
    let checklist: Checklist
    
    @EnvironmentObject var dataController: DataController
    
    @FocusState var focused: Bool
    
    @State var name: String
    @State var showingDeleteConfirm = false
        
    init(checklist: Checklist) {
        self.checklist = checklist
            
        _name = State(wrappedValue: checklist.checklistName)
        }
        
    var body: some View {
        VStack {
            HStack {
                TextField("New List", text: $name)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .onAppear {
                        if name.isEmpty {
                            focused = true
                        }
                    }
                    .focused($focused)
                    .onChange(of: name, perform: { name in checklist.name = name })
                
                Spacer()
                
                Menu {
                    Button {
                        showingDeleteConfirm = true
                    } label: {
                        Label("Delete List", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
            .padding(.top)
            .padding(.horizontal)
            .confirmationDialog("Are you sure you want to this list?", isPresented: $showingDeleteConfirm, titleVisibility: .visible) {
                Button("Delete List", role: .destructive) {
                    dataController.delete(checklist)
                }
            }
            
            Divider()
        }
    }
}

struct ChecklistHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistHeaderView(checklist: Checklist.example)
    }
}
