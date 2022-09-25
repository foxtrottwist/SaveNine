//
//  ProjectDetailView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import PhotosUI
import SwiftUI

struct ProjectDetailView: View {
    @ObservedObject var project: Project
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) private var dismiss
    
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
            PhotoPickerView(uiImage: $image)
                
            Section {
                TextField("Project name", text: $name)
                    .font(.title3)
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            Section {
                TrackerView(project: project)
            }
            .padding()
            
            Section {
                TextField("Notes", text: $detail, axis: .vertical)
                    .lineLimit(...7)
            }
            .padding()
            
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
        .onChange(of: name, perform: { name in project.name = name })
        .onChange(of: detail, perform: { detail in project.detail = detail })
        .onChange(of: image, perform: { image in update(uiImage: image, in: project) })
        .onDisappear(perform: dataController.save)
        .confirmationDialog("Are you sure you want to delete project?", isPresented: $showingDeleteConfirm, titleVisibility: .visible) {
            Button("Delete Project", role: .destructive) {
                delete(project: project)
            }
        }
    }
    
    private func secondsValue(for date: Date) -> Double {
           let seconds = Calendar.current.component(.second, from: date)
           return Double(seconds) / 60
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
