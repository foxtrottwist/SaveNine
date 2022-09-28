//
//  ChecklistRowView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/25/22.
//

import SwiftUI

struct ChecklistRowView: View {
    let item: Item
    
    @FocusState var focused: Bool
    
    @State var name: String
    @State var completed: Bool
    @State var showingItemDetailView = false
    
    
    
    init(item: Item) {
        self.item = item
        
        _name = State(wrappedValue: item.itemName)
        _completed = State(wrappedValue: item.completed)
    }
    
    var body: some View {
        HStack {
            Image(systemName: completed ? "checkmark.square.fill" : "square" )
                .onTapGesture {
                    completed.toggle()
                }
            
            TextField("New Item", text: $name)
                .onAppear {
                    if name.isEmpty {
                        focused = true
                    }
                }
                .focused($focused)
            
            Spacer()
            
            Button {
                showingItemDetailView.toggle()
            } label: {
                Image(systemName: "info.circle")
            }
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
        ChecklistRowView(item: Item.example)
    }
}
