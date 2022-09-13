//
//  ItemListRowView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/11/22.
//

import SwiftUI

struct ItemListRowView: View {
    @State var name: String
    @State var completed: Bool
    @State var showingItemDetailView = false
    
    let item: Item
    
    init(item: Item) {
        self.item = item
        
        _name = State(wrappedValue: item.itemName)
        _completed = State(wrappedValue: item.completed)
    }
    
    var body: some View {
        HStack {
            Image(systemName: completed ? "square" : "checkmark.square.fill")
                .onTapGesture {
                    completed.toggle()
                }
            
            TextField("New Task", text: $name)
            
            Spacer()
            
            Button {
                showingItemDetailView.toggle()
            } label: {
                Image(systemName: "info.circle")
            }
            .buttonStyle(.plain)
        }
        .padding()
        .onChange(of: name, perform: { _ in update() })
        .onChange(of: completed, perform: { _ in update() })
        .sheet(isPresented: $showingItemDetailView) {
            ItemDetailView(name: $name, item: item)
        }
    }
    
    func update() {
        item.itemList?.objectWillChange.send()
        
        item.name = name
        item.completed = completed
    }
}

struct ItemListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListRowView(item: Item.example)
    }
}
