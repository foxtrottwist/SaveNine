//
//  LabelsView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/20/23.
//

import SwiftData
import SwiftUI

struct LabelsView: View {
    @Environment (\.modelContext) private var modelContext
    @Query(sort: \Marker.name, order: .forward) private var markers: [Marker]
    
    var body: some View {
        List {
            ForEach(markers) { marker in
                HStack {
                    Text(marker.displayName)
                    Spacer()
                }
                .contextMenu {
                    Button {
                    // TODO: Implement new context menu delete functionality.
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .onDelete(perform: deleteLabel)
        }
        .navigationTitle("Labels")
        .toolbar {
            EditButton()
        }
    }
    
    private func deleteLabel(at offsets: IndexSet) {
            for offset in offsets {
                let marker = markers[offset]
                modelContext.delete(marker)
            }
        }
}

#Preview {
    LabelsView()
}
