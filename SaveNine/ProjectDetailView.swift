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
    @State private var image: UIImage?
    @State private var showingDeleteConfirm = false
    
    let project: Project
    
    init(project: Project) {
        self.project = project
        
        _name = State(wrappedValue: project.projectName)
        _detail = State(wrappedValue: project.projectDetail)
        
        if !project.projectImage.isEmpty {
            if let uiImage = getImage(named: project.projectImage) {
                _image = State(wrappedValue: uiImage)
            }
        }
    }
    
    var body: some View {
        ScrollView {
           PhotoPickerView(uiImage: $image)
            
            Section {
                TextField("Project name", text: $name)
                    .font(.title3)
            }
            .padding(.horizontal)
            
            Section {
                TextField("Notes", text: $detail, axis: .vertical)
                    .lineLimit(...7)
            }
            .padding()
            
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
        .onChange(of: image, perform: { _ in
            update()
            updateImage()
        })
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
        project.image = "\(project.id!).png"
    }
    
    func updateImage() {
            if let uiImage = image  {
                Task {
                    save(uiImage: uiImage, named: project.projectImage)
                }
            } else {
                deleteImage(named: project.projectImage)
            }
    }
    
    func delete() {
        deleteImage(named: project.projectImage)
        dataController.delete(project)
        dismiss()
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailView(project: Project.example)
    }
}
