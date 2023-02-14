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
                // Temporary Migration code. If an image is stored in the documents directory
                // preform the following.
                let imageName = "\(project.id!)"
                // Save to App Group container
                FileManager.save (uiImage: uiImage, named: imageName)
                // Delete the original file
                deleteFile (named: project.projectImage)
                // Rename the image to the id only (previously the extension was included)
                project.image = imageName
            } else if let uiImage = FileManager.getImage (named: project.projectImage) {
                _image = State (wrappedValue: uiImage)
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
                .onChange(of: detail, perform: { detail in project.detail = detail })
                .onChange(of: image, perform: { image in update(uiImage: image, in: project) })
                .onChange(of: editing, perform: editTags)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear(perform: dataController.save)
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            Button(editing ? "Done" : "Edit", action: editProject)
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
            NavigationLink(destination: SessionsView(sessions: project.projectSessions, sharedSessions: project.projectShareSessions)) {
                Label("Sessions", systemImage: "clock")
            }
            
            NavigationLink(destination: ChecklistView(project: project)) {
                Label("Checklists", systemImage: "checklist")
            }
            
            Divider()
            
            Button {
                project.closed.toggle()
                dataController.save()
                
                dismiss()
            } label: {
                if project.closed {
                    Label("Reopen project", systemImage: "tray.full")
                } else {
                    Label( "Close project", systemImage: "archivebox")
                }
            }
            .disabled(project.tracking)

            Button {
                showingDeleteConfirm.toggle()
            } label: {
                Label("Delete Project", systemImage: "trash")
                    .foregroundColor(.red)
            }
            .disabled(project.tracking)
        } label: {
            Label("Menu", systemImage: "ellipsis.circle")
        }
    }
    
    func editProject() {
        if editing {
            if name.isEmpty {
                name = project.projectName
                project.name = name
            } else {
                project.name = name
            }
        }

        editing.toggle()
    }
    
    func update(uiImage: UIImage?, in project: Project) {
        if let uiImage = uiImage {
            let id = project.id!
            let name = "\(id)"
            project.image = name

            Task {
                FileManager.save(uiImage: uiImage, named: name)
            }
        } else {
            // Temporary Migration code. The first call delete call will be removed.
            deleteFile(named: project.projectImage)
            FileManager.deleteImage(named: project.projectImage)
        }
    }
    
    func editTags(_ editing: Bool) {
        guard !editing, project.projectTagsString != tags else { return }
        
        let tagNames = prepare(tags: tags)
        tags = tagNames.joined(separator: " ")
        
        update(tags: tagNames, in: project)
    }
    
    /// Accepts a string of words and validates that the entered text can be added as a tags.
    /// - Parameter tags: A string representing the tags already associated with or to be added to the project.
    /// - Returns: An array of unique strings representing the tags already associated with or to be added to the project.
    func prepare(tags: String) -> [String] {
        var set = Set<String>()
        // Splits the provided string into separate words verifies
        // that there is only a single instance of a word by attempting
        // to insert them into a Set.
        return tags.components(separatedBy: " ").map { $0.lowercased() }
            .filter { !$0.isEmpty && set.insert($0).inserted }.sorted { $0 < $1 }
    }
    
    
    /// Handles associating of tags with a given project.
    /// - Parameters:
    ///   - tags: An array of strings representing tags to be associated with a project.
    ///   - project: The Project that will be associated with the provided tags.
    func update(tags: [String], in project: Project) {
        let updatedTags = tags.map { tagName in
            // If a tag with the provided name already exists, return
            // it instead of creating a new one.
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
        // Temporary Migration code. The first delete call will be removed
        deleteFile(named: project.projectImage)
        FileManager.deleteImage(named: project.projectImage)
        dataController.delete(project)
        dismiss()
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectDetailView(project: Project.example)
            .environmentObject(dataController)
            .environmentObject(SessionLabels())
    }
}
