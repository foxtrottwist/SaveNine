//
//  ItemListHeaderView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/11/22.
//

import SwiftUI

struct ItemListHeaderView: View {
    @State var name: String
    
    let itemList: ItemList
    
    init(itemList: ItemList) {
        self.itemList = itemList
        
        _name = State(wrappedValue: itemList.itemListName)
    }
    
    var body: some View {
        TextField("List Name", text: $name)
            .font(.title3)
            .foregroundColor(.blue)
            .padding(.top)
            .onChange(of: name, perform: { _ in update() })
        
        Divider()
    }
    
    func update() {
        itemList.name = name
    }
}

struct ItemListHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListHeaderView(itemList: ItemList.example )
    }
}
