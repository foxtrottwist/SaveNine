//
//  ProjectDetail.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import PhotosUI
import SwiftUI

struct ProjectDetail: View {
    @ObservedObject var project: Project
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataController: DataController
    @FetchRequest(sortDescriptors: [SortDescriptor(\Tag.name, order: .forward)]) private var fetchedTags: FetchedResults<Tag>
    @State private var name = ""
    @State private var detail = ""
    @State private var displayTags: String = ""
    @State private var document: ProjectFile?
    @State private var image: UIImage?
    @State private var showingFileExporter = false
    @State private var editing = false
    
    init(project: Project) {
        self.project = project
        _name = State(wrappedValue: project.displayName)
        _detail = State(wrappedValue: project.projectDetail)
        _displayTags = State(wrappedValue: project.displayTags)
        
        if !project.projectImage.isEmpty {
            if let uiImage = FileManager.getImage (named: project.projectImage) {
                _image = State (wrappedValue: uiImage)
            }
        }
    }
    
    var body: some View {
        Form {
            Section {
                ProjectImage(project: project)
            }
            .listRowBackground(Color.clear)
            
         
            Section {
                TrackerView(project: project)
            }
                    
            Section {
                NavigationLink(destination: ProjectSessions(project: project)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Sessions")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .italic()
                            
                            Text("\(project.tracking ? project.projectSessions.count - 1 : project.projectSessions.count)")
                        }
                        
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Time Tracked")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .italic()
                            
                            Text(project.timeTracked)
                        }
                    }
                }
            }
            
            TextField("Notes", text: $detail, axis: .vertical)
                .padding(.bottom)
            
            TextField("Text, separated by spaces", text: $displayTags)
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
                .foregroundColor(Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000))
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
        .navigationTitle($name)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: detail) { project.detail = detail }
        .onChange(of: editing) { editTags(editing) }
        .onDisappear(perform: dataController.save)
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            ToolbarTitleMenu {
                RenameButton()
                
                Button {
                    project.closed.toggle()
                    dismiss()
                } label: {
                    if project.closed {
                        Label("Reopen project", systemImage: "tray.full")
                    } else {
                        Label( "Close project", systemImage: "archivebox")
                    }
                }
                
                Divider()
                
                Button {
                    document = ProjectDocument.document(from: project)
                    showingFileExporter.toggle()
                } label: {
                    Label("Export", systemImage: "square.and.arrow.up")
                }
                .disabled(project.tracking)
            }
        }
    }
    
    private func editTags(_ editing: Bool) {
        guard !editing, project.displayTags != displayTags else { return }
        
        let tagNames = prepare(tags: displayTags)
        displayTags = tagNames.joined(separator: " ")
        update(tags: tagNames, in: project)
    }
    
    /// Accepts a string of words and validates that the entered text can be added as a tags.
    /// - Parameter tags: A string representing the tags already associated with or to be added to the project.
    /// - Returns: An array of unique strings representing the tags already associated with or to be added to the project.
    private func prepare(tags: String) -> [String] {
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
    private func update(tags: [String], in project: Project) {
        let updatedTags = tags.map { tagName in
            // If a tag with the provided name already exists, return
            // it instead of creating a new one.
            if let existingTag = fetchedTags.first(where: { $0.name == tagName }) {
                return existingTag
            } else {
                let newTag = Tag(context: managedObjectContext)
                newTag.id = UUID()
                newTag.name = tagName
                
                return newTag
            }
        }
        project.tags = Set(updatedTags) as NSSet
    }
    
    private func update(uiImage: UIImage?, in project: Project) {
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

#Preview {
    ProjectDetail(project: Project.preview)
        .environment(SessionLabelController.preview)
        .environmentObject(DataController.preview)
}
