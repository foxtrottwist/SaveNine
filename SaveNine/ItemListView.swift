//
//  ItemListView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import SwiftUI

struct ItemListView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String
    @State private var detail: String
    
    let itemList: ItemList
    
    init(itemList: ItemList) {
        self.itemList = itemList
        
        _name = State(wrappedValue: itemList.itemListName)
        _detail = State(wrappedValue: itemList.itemListDetail)
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                    .font(.title3)
                TextField("Description", text: $detail, axis: .vertical)
                    .lineLimit(...7)
                
                List {
                    ForEach(itemList.itemListItems) { item in
                        Text("\(item.itemName)")
                    }
                }
            }
        }
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView(itemList: ItemList.example)
    }
}
