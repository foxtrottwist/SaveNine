//
//  TagDrawerView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 10/3/22.
//

import SwiftUI

struct TagDrawerView: View {
    @Binding var selection: [Ptag]
    @Binding var isPresented: Bool
    
    @FetchRequest(fetchRequest: Ptag.fetchAllTags) var ptags: FetchedResults<Ptag>
    
    let activeTagColor = Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000)
    
    var body: some View {
        if isPresented {
            HStack {
                Button {
                    isPresented.toggle()
                } label: {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000))
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        selection = []
                    }
                } label: {
                    Image(systemName: "tag.slash")
                        .font(.callout)
                    
                    Text("Clear Tags \(selection.count)")
                        .font(.callout)
                        .monospacedDigit()
                }
                .foregroundColor(Color(red: 0.639, green: 0.392, blue: 0.533, opacity: 1.000))
            }
            .padding([.horizontal, .top])
            
            if ptags.isEmpty {
                NoContentView(message: "Add tags to your projects to filter.")
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
    }
    
    private func toggleSelection(tag: Ptag) {
        if let existingIndex = selection.firstIndex(where: { $0.id == tag.id }) {
            selection.remove(at: existingIndex)
        } else {
            selection.append(tag)
        }
    }
}

struct TagDrawerView_Previews: PreviewProvider {
    static var previews: some View {
        TagDrawerView(selection: .constant([Ptag.example]), isPresented: .constant(Bool()))
    }
}
