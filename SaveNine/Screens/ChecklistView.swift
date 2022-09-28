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
                    Text("**Add Checklist**")
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            List {
                ForEach(project.projectChecklists) { checklist in
                    Section {
                        ForEach(checklist.checklistItems) { item in
                            ChecklistRowView(item: item)
                        }
                    } header: {
                        ChecklistHeaderView(checklist: checklist)
                    }
                }
            }
            .listStyle(.inset)
            .scaledToFit()
        }
    }
}

struct ChecklistView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistView(project: Project.example)
    }
}
