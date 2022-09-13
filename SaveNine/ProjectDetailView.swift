//
//  ProjectDetailView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import PhotosUI
import SwiftUI

struct ProjectDetailView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var detail: String
    @State private var selectedImage: [PhotosPickerItem] = []
    @State private var image: Data?
    @State private var showingDeleteConfirm = false
    
    let project: Project
    
    init(project: Project) {
        self.project = project
        
        _name = State(wrappedValue: project.projectName)
        _detail = State(wrappedValue: project.projectDetail)
    }
    
    var body: some View {
        ScrollView {
            Section {
                TextField("Project name", text: $name)
                    .font(.title3)
            }
            .padding(.horizontal)
            
            Section {
                TextField("Notes", text: $detail, axis: .vertical)
                    .lineLimit(...7)
            }
            .padding(.horizontal)
            
            ForEach(project.projectItemLists) { itemList in
                Section {
                    ForEach(itemList.itemListItems) { item in
                        ItemListRowView(item: item)
                    }
                } header: {
                    ItemListHeaderView(itemList: itemList)
                }
                .padding(.horizontal)
            }
            
            Divider()
                .padding()
            
            Section {
                Button {
                    showingDeleteConfirm.toggle()
                } label: {
                    Label("Delete Project", systemImage: "trash")
                        .foregroundColor(.red)
                }
            }
            .padding(.vertical)
        }
        .onChange(of: name, perform: { _ in update() })
        .onChange(of: detail, perform: { _ in update() })
        .onDisappear(perform: dataController.save)
        .confirmationDialog("Are you sure you want to delete project?", isPresented: $showingDeleteConfirm, titleVisibility: .visible) {
            Button("Delete Project", role: .destructive) {
                delete()
            }
        }
    }
    
    func update() -> Void {
        project.name = name
        project.detail = detail
        
    }
    
    func delete() {
        dataController.delete(project)
        dismiss()
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailView(project: Project.example)
    }
}
