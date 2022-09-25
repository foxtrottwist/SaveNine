//
//  ChecklistRowView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/25/22.
//

import SwiftUI

struct ChecklistRowView: View {
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
                Image(systemName: completed ? "checkmark.square.fill" : "square" )
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
                ItemDetailView(item: item, name: $name)
            }
        }
        
        func update() {
            item.name = name
            item.completed = completed
        }
}

struct ChecklistRowView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistRowView(item: Item.example)
    }
}
