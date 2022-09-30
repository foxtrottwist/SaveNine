//
//  ChecklistHeaderView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/25/22.
//

import SwiftUI

struct ChecklistHeaderView: View {
    let checklist: Checklist
    
    @Environment(\.managedObjectContext) var managedObjectContext
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
                    .foregroundColor(.blue)
                    .onAppear {
                        if name.isEmpty {
                            focused = true
                        }
                    }
                    .focused($focused)
                    .onSubmit {
                        if name.isEmpty {
                            name = checklist.checklistName.isEmpty ? "New List" : checklist.checklistName
                        }
                    }
                    .submitLabel(.done)
                
                Spacer()
                
                Menu {
                    Button {
                        showingDeleteConfirm = true
                    } label: {
                        Label("Delete List", systemImage: "trash")
                    }
                    
                    Button {
                        withAnimation {
                            addItem(to: checklist)
                        }
                    } label: {
                        Label("Add New Item", systemImage: "plus")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
            .confirmationDialog("Are you sure you want to this list? All items in this list will be deleted as well.", isPresented: $showingDeleteConfirm, titleVisibility: .visible) {
                Button("Delete List", role: .destructive) {
                    dataController.delete(checklist)
                }
            }
        }
    }
    
    func addItem(to checklist: Checklist) {
        checklist.project?.objectWillChange.send()
        
        let item = Item(context: managedObjectContext)
        item.checklist = checklist
        item.creationDate = Date()
        
        dataController.save()
    }
}

struct ChecklistHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistHeaderView(checklist: Checklist.example)
    }
}
