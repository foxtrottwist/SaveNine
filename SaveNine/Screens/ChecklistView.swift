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
        List {
            if project.projectChecklists.isEmpty {
                Text("Add lists to track supplies, tasks and more.")
                    .italic()
                    .foregroundColor(.secondary)
            } else {
                ForEach(project.projectChecklists) { checklist in
                    Section {
                        ForEach(checklist.checklistItems) { item in
                            ChecklistRowView(item: item)
                        }
                        .onDelete(perform: { offsets in
                            let items = checklist.checklistItems
                            
                            for offset in offsets {
                                let item = items[offset]
                                dataController.delete(item)
                            }
                            
                            dataController.save()
                        })
                    } header: {
                        ChecklistHeaderView(checklist: checklist, addItem: addItem(to: checklist))
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Button {
                        let checklist = Checklist(context: managedObjectContext)
                        checklist.project = project
                        checklist.creationDate = Date()
                        
                        dataController.save()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                        Text("**Add Checklist**")
                    }
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
}

struct ChecklistView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistView(project: Project.example)
    }
}
