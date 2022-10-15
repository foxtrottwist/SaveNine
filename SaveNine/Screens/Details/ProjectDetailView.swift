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
    
    @Environment(\.defaultMinListRowHeight) var defaultMinListRowHeight
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataController: DataController
    
    @FetchRequest(fetchRequest: Ptag.fetchAllTags) var ptags: FetchedResults<Ptag>
    
    @State private var name = ""
    @State private var detail = ""
    @State private var image: UIImage?
    @State private var showingDeleteConfirm = false
    @State private var tags: String = ""
    @State private var editing = false
    
    init(project: Project) {
        self.project = project
        
        _name = State(wrappedValue: project.projectName)
        _detail = State(wrappedValue: project.projectDetail)
        _tags = State(wrappedValue: project.projectTagsString)
        
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
                    .disabled(!editing)
                
                if !editing {
                    Text(name).font(.title2)
                    Divider()
                    
                    TrackerView(project: project)
                    projectDetailLinks
                    
                }
                
                Form {
                    if editing {
                        Text("Project Name")
                            .font(.callout)
                            .fontWeight(.light)
                        
                        TextField("Project Name", text: $name)
                            .padding(.bottom)
                    }
                              
                    Text("Notes")
                        .font(.callout)
                        .fontWeight(.light)
                        .italic()
                    
                    TextField("Notes", text: $detail, axis: .vertical)
                        .padding(.bottom)
                    
                    Text("Tags")
                        .font(.callout)
                        .fontWeight(.light)
                        .italic()
                    
                    TextField("Text, separated by spaces", text: $tags)
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                        .foregroundColor(Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000))
                }
                .animation(.easeIn, value: editing)
                .disabled(!editing)
                .formStyle(.columns)
                .padding()
                .onChange(of: name, perform: { name in project.name = name })
                .onChange(of: detail, perform: { detail in project.detail = detail })
                .onChange(of: image, perform: { image in update(uiImage: image, in: project) })
                .onChange(of: editing, perform: editTags)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear(perform: dataController.save)
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            Button(editing ? "Done" : "Edit", action: { editing.toggle() })
            projectDetailsMenuToolbarItem
        }
        .confirmationDialog("Are you sure you want to delete this project?", isPresented: $showingDeleteConfirm, titleVisibility: .visible) {
            Button("Delete Project", role: .destructive) {
                delete(project: project)
            }
        }
    }
    
    var projectDetailsMenuToolbarItem: some View {
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
            Label("Menu", systemImage: "ellipsis.circle")
        }
    }
    
    var projectDetailLinks: some View {
        List {
            NavigationLink(destination: SessionsView(sessions: project.projectSessions, sharedSessions: project.projectShareSessions)) {
                Label("Sessions", systemImage: "stopwatch")
            }
            
            NavigationLink(destination: ChecklistView(project: project)) {
                Label("Checklists", systemImage: "list.triangle")
            }
        }
        .frame(height: defaultMinListRowHeight * 2)
        .listStyle(.plain)
    }
    
    func update(uiImage: UIImage?, in project: Project) {
        if let uiImage = uiImage {
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
    
    func prepare(tags: String) -> [String] {
        var set = Set<String>()
        
        return tags.components(separatedBy: " ").map { $0.lowercased() }
            .filter { !$0.isEmpty && set.insert($0).inserted }.sorted { $0 < $1 }
    }
    
    func editTags(_ editing: Bool) {
        guard !editing, project.projectTagsString != tags else { return }
        
        let tagNames = prepare(tags: tags)
        tags = tagNames.joined(separator: " ")
        
        update(tags: tagNames, in: project)
    }
    
    func update(tags: [String], in project: Project) {
        let updatedTags = tags.map { tagName in
            if let existingTag = ptags.first(where: { $0.name == tagName }) {
                return existingTag
            } else {
                let newTag = Ptag(context: managedObjectContext)
                newTag.id = UUID()
                newTag.name = tagName
                
                return newTag
            }
        }
        
        project.tags = Set(updatedTags) as NSSet
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
