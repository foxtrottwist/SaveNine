//
//  LabelsView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/20/23.
//

import SwiftUI

struct LabelsView: View {
    @Environment(SessionLabelController.self)  private var sessionLabelController
    
    var body: some View {
        List {
            ForEach(sessionLabelController.labels) { label in
                HStack {
                    Text(label.name)
                    Spacer()
                }
                .contextMenu {
                    Button {
                        sessionLabelController.remove(label: label)
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
                let label = sessionLabelController.labels[offset]
                sessionLabelController.remove(label: label)
            }
        }
}

struct LabelsView_Previews: PreviewProvider {
    static var previews: some View {
        LabelsView()
            .environment(SessionLabelController.preview)
    }
}
