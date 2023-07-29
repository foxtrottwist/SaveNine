//
//  TagView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 10/7/22.
//

import SwiftUI

struct TagView: View {
    let tag: Tag
    let isActive: Bool
    
    @EnvironmentObject var dataController: DataController
    
    @FetchRequest(fetchRequest: Tag.fetchAllTags) var tags: FetchedResults<Tag>
    
    @State private var name: String
    @State private var showingDeleteTagConfirmation = false
    @State private var showingFailedToRenameAlert = false
    @State private var showingRenameAlert = false
    
    let activeTagColor = Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000)
    
    init(tag: Tag, isActive: Bool) {
        self.tag = tag
        self.isActive = isActive
        
        _name = State(wrappedValue: tag.tagName)
    }
    
    var body: some View {
        VStack {
            Text(tag.tagName)
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
                Label("Rename", systemImage: "pencil")
            }
            
            Divider()
            
            Button {
                showingDeleteTagConfirmation.toggle()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .alert("Rename Tag", isPresented: $showingRenameAlert) {
            UpdateNameView(name: $name,  cancelAction: cancelAction, confirmAction: renameAction)
        }
        .alert("Failed to Rename Tag", isPresented: $showingFailedToRenameAlert) {} message: {
            Text("Could not rename tag, tag name already exists.")
        }
        .confirmationDialog("Are you sure you want to delete this tag?", isPresented: $showingDeleteTagConfirmation, titleVisibility: .visible) {
            Button("Delete Tag", role: .destructive) {
                dataController.delete(tag)
            }
        }
    }
    
    func renameAction() {
        if name != tag.tagName && !name.isEmpty {
            // If a tag with the provided name already exists
            // prevent having a duplicate tag and inform the user.
            if tags.contains(where: { $0.name == name }) {
                showingFailedToRenameAlert.toggle()
                name = tag.tagName
            } else {
                tag.tagProjects.forEach {
                    $0.objectWillChange.send()
                }
                
                tag.name = name.lowercased()
                dataController.save()
            }
        }
    }
    
    func cancelAction() {
        name = tag.tagName
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(tag: Tag.example, isActive: false)
    }
}
