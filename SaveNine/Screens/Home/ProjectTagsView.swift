//
//  ProjectTagsView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 10/3/22.
//

import SwiftUI

struct ProjectTagsView: View {
    @Binding var selection: [Ptag]
    
    @FetchRequest(fetchRequest: Ptag.fetchAllTags) var ptags: FetchedResults<Ptag>
    
    let activeTagColor = Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000)
    
    var body: some View {
        if ptags.isEmpty {
            Text("Add tags to your projects to filter.")
                .italic()
                .foregroundColor(.secondary)
                .padding(.vertical)
        } else {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(ptags) { tag in
                        Button {
                            toggleSelection(tag: tag)
                        } label: {
                            TagView(tag: tag, isActive: selection.contains(tag))
                        }
                    }
                }
                .buttonStyle(.plain)
                .padding()
            }
        }
    }
    
    private func toggleSelection(tag: Ptag) {
        if let existingIndex = selection.firstIndex(where: { $0.id == tag.id }) {
            selection.remove(at: existingIndex)
        } else {
            selection.append(tag)
        }
    }
}

struct ProjectFiltersView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectTagsView(selection: .constant([Ptag.example]))
    }
}
