//
//  ItemDetailView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/25/22.
//

import SwiftUI

struct ItemDetailView: View {
    let item: Item
    
    @Binding var name: String
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataController: DataController
        
    @State private var detail: String
    @State private var priority: Int
        
    init(item: Item, name: Binding<String>) {
        self.item = item
            
        _name = name
        _detail = State(wrappedValue: item.itemDetail)
        _priority = State(wrappedValue: Int(item.priority))
    }
        
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                TextField("Notes", text: $detail, axis: .vertical)
                    .lineLimit(...7)
                
                Section {
                    Picker("Priority", selection: $priority) {
                        Text("Low").tag(1)
                        Text("Medium").tag(2)
                        Text("High").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                } header: {
                    Text("Priority")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Details")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("**Done**") {
                        save()
                        dismiss()
                    }
                }
            }
        }
    }
        
    func save() {
        item.name = name
        item.detail = detail
        item.priority = Int16(priority)
        
        dataController.save()
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(item: Item.example, name:.constant(Item.example.itemName))
    }
}
