//
//  ChecklistView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 9/25/22.
//

import SwiftUI

struct ChecklistView: View {
    @ObservedObject var project: Project
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    let checklist = Checklist(context: managedObjectContext)
                    checklist.project = project
                    checklist.creationDate = Date()
                    
                    dataController.save()
                } label: {
                    Label("Add List", systemImage: "list.dash")
                }
                
                Spacer()
            }
            .padding()
                        
            ForEach(project.projectChecklists) { checklist in
                Section {
                    ForEach(checklist.checklistItems) { item in
                        ChecklistRowView(item: item)
                    }
                    
                    Button {
                        withAnimation {
                            addItem(to: checklist)
                        }
                    } label: {
                        Label("Add New Item", systemImage: "plus")
                    }
                } header: {
                    ChecklistHeaderView(checklist: checklist)
                }
                .padding(.horizontal)
            }
        }
    }
    
    func addItem(to checklist: Checklist) {
        checklist.project?.objectWillChange.send()
        
        let item = Item(context: managedObjectContext)
        item.checklist = checklist
        item.creationDate = Date()
        
        dataController.save()
    }
}

struct ChecklistView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistView(project: Project.example)
    }
}
