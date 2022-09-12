//
//  ItemListRowView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/11/22.
//

import SwiftUI

struct ItemListRowView: View {
    @State var name: String
    @State var showingItemDetailView = false
    
    let item: Item
    
    init(item: Item) {
        self.item = item
        
        _name = State(wrappedValue: item.itemName)
    }
    
    var body: some View {
        HStack {
            TextField("New item", text: $name)
            Spacer()
            Button {
                showingItemDetailView.toggle()
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }
        }
        .onChange(of: name, perform: { _ in update() })
        .sheet(isPresented: $showingItemDetailView) {
            ItemDetailView(name: $name, item: item)
        }
    }
    
    func update() {
        item.itemList?.objectWillChange.send()
        
        item.name = name
    }
}

struct ItemListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListRowView(item: Item.example)
    }
}
