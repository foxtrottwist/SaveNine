//
//  ProjectDetailView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import PhotosUI
import SwiftUI

struct ProjectDetailView: View {
    let project: Project
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dataController: DataController
    
    @State private var name = ""
    @State private var detail = ""
    @State private var image: UIImage?
    @State private var showingDeleteConfirm = false
    
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
            VStack {
                PhotoPickerView(uiImage: $image)
                
                TrackerView(project: project)
                    .padding()
                
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
                
                Section {
                    ChecklistView(project: project)
                }
            }
            .navigationTitle(project.projectName)
            .onChange(of: name, perform: { name in project.name = name })
            .onChange(of: detail, perform: { detail in project.detail = detail })
            .onChange(of: image, perform: { image in update(uiImage: image, in: project) })
            .onDisappear(perform: dataController.save)
            .toolbar {
                Menu {
                    Button {
                        project.closed.toggle()

                        dataController.save()

                        dismiss()
                    } label: {
                        if project.closed {
                            Label("Reopen project", systemImage: "tray.full")
                        } else {
                            Label( "Archive project", systemImage: "archivebox")
                        }
                    }

                    Divider()

                    Button {
                        showingDeleteConfirm.toggle()
                    } label: {
                        Label("Delete Project", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                } label: {
                    Label("menu", systemImage: "ellipsis.circle")
                }
            }
            .confirmationDialog("Are you sure you want to delete this project?", isPresented: $showingDeleteConfirm, titleVisibility: .visible) {
                Button("Delete Project", role: .destructive) {
                    delete(project: project)
                }
            }
        }
    }
    
    func update(uiImage: UIImage?, in project: Project) {
        if let uiImage = uiImage  {
            let id = project.id!
            let name = "\(id).png"
            project.image = name
            
            Task {
                save(uiImage: uiImage, named: name)
            }
        } else {
            deleteFile(named: name)
        }
    }
    
    func delete(project: Project) {
        deleteFile(named: project.projectImage)
        dataController.delete(project)
        dismiss()
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailView(project: Project.example)
    }
}
