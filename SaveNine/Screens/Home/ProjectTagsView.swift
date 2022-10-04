//
//  ProjectTagsView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 10/3/22.
//

import SwiftUI

struct ProjectTagsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataController: DataController
    
    @FetchRequest(fetchRequest: Ptag.fetchAllTags) var ptags: FetchedResults<Ptag>
    
    var body: some View {
        List {
            Button("Delete Tags") {
                ptags.forEach { dataController.delete($0) }
                dataController.save()
            }
            
            Section {
                ForEach(ptags) { tag in
                    Text(tag.ptagName)
                }
            }
        }
    }
}

struct ProjectFiltersView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectTagsView()
    }
}
