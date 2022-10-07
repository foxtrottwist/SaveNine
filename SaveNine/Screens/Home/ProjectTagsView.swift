//
//  ProjectTagsView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 10/3/22.
//

import SwiftUI

struct ProjectTagsView: View {
    @Binding var selection: [Ptag]
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataController: DataController
    
    @FetchRequest(fetchRequest: Ptag.fetchAllTags) var ptags: FetchedResults<Ptag>
    
    let activeTagColor = Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000)
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                if let ptags {
                    Button {
                        selection = []
                    } label: {
                        TagView(name: "all tags", color: selection.isEmpty ? activeTagColor : .clear)
                    }
                    .buttonStyle(.plain)
                    
                    ForEach(ptags) { tag in
                        Button {
                           toggleSelection(tag: tag)
                        } label: {
                            TagView(name: tag.ptagName, color: selected(tag) ? activeTagColor : .clear)
                        }
                    }
                    .buttonStyle(.plain)
                } else {
                    Text("Add tags to your projects to filter projects shown in the list.")
                        .italic()
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
    }
    
    private func toggleSelection(tag: Ptag) {
        if let existingIndex = selection.firstIndex(where: { $0.id == tag.id }) {
            selection.remove(at: existingIndex)
        } else {
            selection.append(tag)
        }
    }
    
    private func selected(_ tag: Ptag) -> Bool {
        return selection.contains(tag)
    }
}

struct ProjectFiltersView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectTagsView(selection: .constant([Ptag.example]))
    }
}
