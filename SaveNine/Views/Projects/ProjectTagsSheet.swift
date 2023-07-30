//
//  ProjectTagsSheet.swift
//  SaveNine
//
//  Created by Lawrence Horne on 7/30/23.
//

import SwiftData
import SwiftUI

struct ProjectTagsSheet: View {
    var project: Project
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\Tag.name, order: .forward)]) private var fetchedTags: FetchedResults<Tag>
    @State private var newTags: [Tag] = []
    @State private var tag = ""
    @State private var tagsPendingAddition: [Tag] = []
    @State private var tagsPendingRemoval: [Tag] = []
    
    var tags: [Tag] {
        (newTags + fetchedTags).sorted(using: KeyPathComparator(\.name, order: .forward))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("New Tag", text: $tag)
                    .onKeyPress(.space) {
                        addTag()
                        return .handled
                    }
                    .onSubmit(addTag)
                    
                Section {
                    List {
                        ForEach(tags) { tag in
                            let selected = !tagsPendingRemoval.contains(tag) && (
                                ((project.tags?.contains(tag)) != nil) || tagsPendingAddition.contains(tag)
                            )
                            
                            Button {
                                handleSelection(tag: tag, isSelected: selected)
                            } label: {
                                TagLabel(name: tag.name!, isSelected: selected)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tags")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        addTag()
                        newTags.removeAll()
//                        tagsPendingAddition.forEach { project.tags.append($0) }
                        tagsPendingRemoval.forEach(removeTag)
                        dismiss()
                    }
                    .bold()
                }
            })
        }
    }
    
    struct TagLabel: View {
        let name: String
        let isSelected: Bool
        
        var body: some View {
            Text(name)
                .padding()
                .foregroundColor(isSelected ? .white : .primary)
                .background(isSelected ? .accent : .clear)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(isSelected ? .clear : .accent, lineWidth: 2)
                }
        }
    }
    
    private func addTag() {
//        guard !tag.isEmpty else { return }
//        let name = tag.trimmingCharacters(in: .whitespaces)
//        let existingTag = fetchedTags.first(where: { $0.name?.lowercased() == name.lowercased() })
//
//        if let existingTag {
//            tagsPendingAddition.append(existingTag)
//            tag.removeAll()
//            return
//        }
//
//        let newTag = Tag(name: name, projects: [])
//        tagsPendingAddition.append(newTag)
//        newTags.append(newTag)
//        tag.removeAll()
    }
    
    private func handleSelection(tag: Tag, isSelected selected: Bool) {
        if selected {
            tagsPendingRemoval.append(tag)
            tagsPendingAddition = tagsPendingAddition.filter { $0.name != tag.name }
        } else {
            tagsPendingAddition.append(tag)
            tagsPendingRemoval = tagsPendingRemoval.filter { $0.name != tag.name }
        }
    }
    
    private func removeTag(tag: Tag) {
//        if let index = project.tags.firstIndex(of: tag) {
//            project.tags.remove(at: index)
//        }
    }
}

//#Preview {
//    ProjectTagsSheet()
//}
