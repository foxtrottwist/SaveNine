//
//  TagView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 10/7/22.
//

import SwiftUI

struct TagView: View {
    let tag: Ptag
    let isActive: Bool
    
    @EnvironmentObject var dataController: DataController
    
    @State var name: String
    @State var showingRenameAlert = false
    @State var showingDeleteTagConfirmation = false
    
    let activeTagColor = Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000)
    
    init(tag: Ptag, isActive: Bool) {
        self.tag = tag
        self.isActive = isActive
        
        _name = State(wrappedValue: tag.ptagName)
    }
    
    var body: some View {
        VStack {
            Text(tag.ptagName)
        }
        .padding(10)
        .background(Color(.systemGroupedBackground))
        .clipShape(Capsule(style: .continuous))
        .overlay {
            Capsule(style: .continuous)
                .stroke(isActive ? activeTagColor : .clear, lineWidth: 2)
        }
        .contextMenu {
            Button {
                showingRenameAlert.toggle()
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            
            Divider()
            
            Button {
                showingDeleteTagConfirmation.toggle()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .alert("Rename Tag", isPresented: $showingRenameAlert) {
            RenameTagView(name: $name) {
                tag.ptagProjects.forEach {
                    $0.objectWillChange.send()
                }
                
                tag.name = name.lowercased()
                
                dataController.save()
            }
        } message: {
            Text("Rename \(tag.ptagName) tag.")
        }
        .confirmationDialog("Are you sure you want to this tag?", isPresented: $showingDeleteTagConfirmation, titleVisibility: .visible) {
            Button("Delete Tag", role: .destructive) {
                dataController.delete(tag)
                
                dataController.save()
            }
        }
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(tag: Ptag.example, isActive: false)
    }
}
