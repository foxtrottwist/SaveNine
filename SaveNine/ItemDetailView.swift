//
//  ItemDetailView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/11/22.
//

import SwiftUI

struct ItemDetailView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    
    @Binding var name: String
    
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool
    
    let item: Item
    
    
    init(name: Binding<String>, item: Item) {
        self.item = item
        
        _name = name
        _detail = State(wrappedValue: item.itemDetail)
        _priority = State(wrappedValue: Int(item.priority))
        _completed = State(wrappedValue: item.completed)
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
                
                Section {
                    Toggle("Mark Completed", isOn: $completed)
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
                    Button("**Save**") {
                        save()
                        dismiss()
                    }
                }
            }
        }
    }
    
    func save() {
        item.itemList?.objectWillChange.send()
        
        item.name = name
        item.detail = detail
        item.priority = Int16(priority)
        item.completed = completed
        
        dataController.save()
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(name:.constant(Item.example.itemName) ,item: Item.example)
    }
}
