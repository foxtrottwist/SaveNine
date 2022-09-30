//
//  ChecklistRowView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/25/22.
//

import SwiftUI

struct ChecklistRowView: View {
    let item: Item
    let addItem: () -> Void
    
    @EnvironmentObject var dataController: DataController
    
    @FocusState var focused: Bool
    
    @State var name: String
    @State var completed: Bool
    @State var showingItemDetailView = false
    
    
    
    init(item: Item, addItem: @escaping () -> Void) {
        self.item = item
        self.addItem = addItem
        
        _name = State(wrappedValue: item.itemName)
        _completed = State(wrappedValue: item.completed)
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: completed ? "checkmark.square.fill" : "square" )
                .font(.title3)
                .onTapGesture {
                    completed.toggle()
                }
            
            TextField("New Item", text: $name, axis: .vertical)
                .focused($focused)
                .onAppear {
                    if name.isEmpty {
                        focused = true
                    }
                }
                .onSubmit {
                    if name.isEmpty {
                        item.checklist?.project?.objectWillChange.send()
                        
                        dataController.delete(item)
                    } else {
                        addItem()
                    }
                }
            
            Spacer()
            
            Button {
                showingItemDetailView.toggle()
            } label: {
                Image(systemName: "info.circle")
            }
            .font(.title3)
            .buttonStyle(.plain)
        }
        .onChange(of: name, perform: { name in item.name = name })
        .onChange(of: completed, perform: { completed in item.completed = completed })
        .sheet(isPresented: $showingItemDetailView) {
            ItemDetailView(item: item, name: $name)
        }
    }
}

struct ChecklistRowView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistRowView(item: Item.example, addItem: {})
    }
}
