//
//  ChecklistHeaderView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/25/22.
//

import SwiftUI

struct ChecklistHeaderView: View {
    let checklist: Checklist
    let addItem: () -> Void
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataController: DataController
    
    @FocusState var focused: Bool
    
    @State var name: String
    @State var showingDeleteConfirm = false
        
    init(checklist: Checklist, addItem: @escaping () -> Void) {
        self.checklist = checklist
        self.addItem = addItem
            
        _name = State(wrappedValue: checklist.checklistName)
        }
        
    var body: some View {
        VStack {
            HStack {
                TextField("New List", text: $name)
                    .focused($focused)
                    .font(.headline)
                    .foregroundColor(.blue)
                    .onAppear {
                        if name.isEmpty {
                            focused = true
                        }
                    }
                    .onSubmit {
                        if name.isEmpty {
                            name = checklist.checklistName.isEmpty ? "New List" : checklist.checklistName
                            checklist.name = name
                        } else {
                            checklist.name = name
                        }
                    }
                    .submitLabel(.done)
                
                Spacer()
                
                Menu {
                    Button {
                        withAnimation {
                            addItem()
                        }
                    } label: {
                        Label("Add New Item", systemImage: "plus")
                    }
                    
                    Divider()
                    
                    Button {
                        showingDeleteConfirm = true
                    } label: {
                        Label("Delete List", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                }
            }
            .confirmationDialog("Are you sure you want to this list? All items in this list will be deleted as well.", isPresented: $showingDeleteConfirm, titleVisibility: .visible) {
                Button("Delete List", role: .destructive) {
                    dataController.delete(checklist)
                }
            }
        }
    }
}

struct ChecklistHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistHeaderView(checklist: Checklist.example, addItem: {})
    }
}
