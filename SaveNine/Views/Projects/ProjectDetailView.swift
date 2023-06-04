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
    @State private var document: ProjectFile?
    @State private var image: UIImage?
    @State private var showingDeleteConfirm = false
    @State private var showingFileExporter = false
    @State private var tags: String = ""
    @State private var editing = false
    
    init(project: Project) {
        self.project = project
        _name = State(wrappedValue: project.projectName)
        _detail = State(wrappedValue: project.projectDetail)
        _tags = State(wrappedValue: project.projectTagsString)
        
        if !project.projectImage.isEmpty {
            if let uiImage = FileManager.getImage (named: project.projectImage) {
                _image = State (wrappedValue: uiImage)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            PhotoPickerView(uiImage: $image)
                .padding(.bottom)
                .disabled(!editing)
                .onChange(of: image, perform: { image in update(uiImage: image, in: project) })
            
            if !editing {
                TrackerView(project: project)
                    
                List {
                    NavigationLink(destination: ProjectSessionsView(project: project)) {
                        HStack {
                            VStack {
                                Text("Sessions:")
                                    .font(.callout)
                                    .fontWeight(.light)
                                    .italic()
                                
                                Text("\(project.tracking ? project.projectSessions.count - 1 : project.projectSessions.count)")
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("Time Tracked:")
                                    .font(.callout)
                                    .fontWeight(.light)
                                    .italic()
                                
                                Text(project.projectFormattedTotalDuration)
                            }
                        }
                    }
                }
                .frame(minHeight: 130)
            }
            
            ProjectFormView(editing: editing, name: $name, detail: $detail, tags: $tags)
                .onChange(of: detail, perform: { detail in project.detail = detail })
                .onChange(of: editing, perform: editTags)
        }
        .confirmationDialog(
            "Are you sure you want to delete this project?",
            isPresented: $showingDeleteConfirm,
            titleVisibility: .visible
        ) {
            Button("Delete Project", role: .destructive) {
                delete(project: project)
            }
        }
        .fileExporter(
            isPresented: $showingFileExporter,
            document: document,
            contentType: .json,
            defaultFilename: name
        ) { result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear(perform: dataController.save)
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            Button(editing ? "Done" : "Edit", action: editProject)
            
            Menu {
                Button {
                    document = ProjectDocument.document(from: project)
                    showingFileExporter.toggle()
                } label: {
                    Label("Export", systemImage: "square.and.arrow.up")
                }
                .disabled(project.tracking)
                
                Button {
                    toggleProjectClosed()
                } label: {
                    if project.closed {
                        Label("Reopen project", systemImage: "tray.full")
                    } else {
                        Label( "Close project", systemImage: "archivebox")
                    }
                }
                
                Divider()
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
            .disabled(editing || project.tracking)
        }
    }
    
    func delete(project: Project) {
        FileManager.deleteImage(named: project.projectImage)
        dataController.delete(project)
        dismiss()
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
    
    func toggleProjectClosed() {
        project.closed.toggle()
        project.managedObjectContext?.refreshAllObjects()
        dismiss()
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
            FileManager.deleteImage(named: project.projectImage)
            project.image = nil
        }
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectDetailView(project: Project.example)
            .environmentObject(dataController)
            .environmentObject(SessionLabelController.preview)
    }
}
