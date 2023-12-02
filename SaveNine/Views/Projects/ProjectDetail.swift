//
//  ProjectDetail.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import PhotosUI
import OSLog
import SwiftUI

struct ProjectDetail: View {
    var project: Project
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var name = ""
    @State private var detail = ""
    @State private var document: ProjectFile?
    @State private var showingDeleteConfirmation = false
    @State private var showingFileExporter = false
    @State private var showingTagsSheet = false
    
    init(project: Project) {
        self.project = project
        _name = State(wrappedValue: project.displayName)
        _detail = State(wrappedValue: project.projectDetail)
    }
    
    var body: some View {
        Form {
            Section {
                ProjectImage(project: project)
            }
            .listRowBackground(Color.clear)
            
            Section {
                TextField("Notes", text: $detail, axis: .vertical)
                    .padding(.bottom)
            }
            
            Section {
                NavigationLink(destination: ProjectSessions(project: project)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Sessions")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .italic()
                            
                            Text("\(project.tracking ?? false ? project.projectSessions.count - 1 : project.projectSessions.count)")
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
            
            Button {
                showingTagsSheet.toggle()
            } label: {
                Label("Manage Tags", systemImage: "tag.square")
            }
        }
        .safeAreaInset(edge: .bottom, content: {
            Tracker(project: project)
        })
        .fileExporter(
            isPresented: $showingFileExporter,
            document: document,
            contentType: .json,
            defaultFilename: name
        ) { result in
            switch result {
            case .success(let url):
                Logger.data.info("Saved to \(url)")
            case .failure(let error):
                Logger.data.error("\(error.localizedDescription)")
            }
        }
        .navigationTitle($name)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: detail) { project.detail = detail }
        .onChange(of: name) { project.name = name }
        .scrollDismissesKeyboard(.interactively)
        .sheet(isPresented: $showingTagsSheet, content: {
            ProjectTagsSheet(project: project)
        })
        .toolbar {
            ToolbarTitleMenu {
                RenameButton()
                
                Button {
                    project.closed!.toggle()
                    dismiss()
                } label: {
                    if project.closed! {
                        Label("Reopen project", systemImage: "tray.full")
                    } else {
                        Label( "Close project", systemImage: "archivebox")
                    }
                }
                
                Button {
                    document = ProjectDocument.document(from: project)
                    showingFileExporter.toggle()
                } label: {
                    Label("Export", systemImage: "square.and.arrow.up")
                }
                .disabled(project.tracking ?? false)
                
                Divider()
                
                Button(role: .destructive) {
                    showingDeleteConfirmation = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(project.tracking ?? false)
            }
        }
        .confirmationDialog(
            "Are you sure you want to delete this project? This cannot be undone.",
            isPresented: $showingDeleteConfirmation
        ) {
            Button("Delete Project", role: .destructive) {
                dismiss()
                modelContext.delete(project)
            }
        }
    }
}

#Preview {
    ProjectDetail(project: Project.preview)
}

