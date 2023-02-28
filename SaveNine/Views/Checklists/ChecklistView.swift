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
        if project.projectChecklists.isEmpty {
          NoContentView(message: "Add lists to track supplies, tasks and more.")
                .toolbar {
                    addChecklistToolbarItem
                }
        } else {
            List {
                ForEach(project.projectChecklists) { checklist in
                    Section {
                        ForEach(checklist.checklistItems) { item in
                            ChecklistRowView(item: item)
                        }
                        .onDelete(perform: { offsets in
                            delete(checklist: checklist, offsets: offsets)
                        })
                    } header: {
                        ChecklistHeaderView(checklist: checklist, addItem: addItem(to: checklist))
                    }
                }
            }
            .listStyle(.plain)
            .scrollDismissesKeyboard(.interactively)
            .toolbar {
                addChecklistToolbarItem
            }
        }
    }
    
    var addChecklistToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            HStack {
                Button {
                    let checklist = Checklist(context: managedObjectContext)
                    checklist.project = project
                    checklist.creationDate = Date()
                    
                    dataController.save()
                } label: {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Checklist")
                        .bold()
                }
            }
        }
    }
    
    func addItem(to checklist: Checklist) -> () -> Void {
        return {
            checklist.project?.objectWillChange.send()
            
            let item = Item(context: managedObjectContext)
            item.checklist = checklist
            item.creationDate = Date()
            
            dataController.save()
        }
    }
    
    func delete(checklist: Checklist, offsets: IndexSet) {
        let items = checklist.checklistItems
        
        for offset in offsets {
            let item = items[offset]
            dataController.delete(item)
        }
    }
}

struct ChecklistView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistView(project: Project.example)
    }
}
