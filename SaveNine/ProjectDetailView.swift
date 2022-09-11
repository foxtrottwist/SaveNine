//
//  ProjectDetailView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/10/22.
//

import SwiftUI

struct ProjectDetailView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String
    @State private var detail: String
    
    let project: Project
    
    init(project: Project) {
        self.project = project
        
        _name = State(wrappedValue: project.projectName)
        _detail = State(wrappedValue: project.projectDetail)
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Project name", text: $name)
                TextField("Notes", text: $detail, axis: .vertical)
                    .lineLimit(...7)
            }
            
            ForEach(project.projectItemLists) { itemList in
                Section {
                    ForEach(itemList.itemListItems) { item in
                        ItemListRowView(item: item)
                    }
                } header: {
                    ItemListHeaderView(itemList: itemList)
                }
            }
        }
        .onChange(of: name, perform: { _ in update() })
        .onChange(of: detail, perform: { _ in update() })
        .onDisappear(perform: dataController.save)
    }
    
    func update() -> Void {
        project.name = name
        project.detail = detail
        
    }
    
    func delete() {
        dataController.delete(project)
        dismiss()
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailView(project: Project.example)
    }
}
