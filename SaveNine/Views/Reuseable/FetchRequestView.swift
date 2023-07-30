//
//  FetchRequestView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 11/8/22.
//

import CoreData
import SwiftUI

struct FetchRequestView<T: NSManagedObject, Content: View>: View {
    @FetchRequest var fetchedResults: FetchedResults<T>
    
    let content: (FetchedResults<T>) -> Content
    
    init(_ fetchRequest: NSFetchRequest<T>, @ViewBuilder _ content: @escaping (FetchedResults<T>) -> Content) {
        _fetchedResults  = FetchRequest(fetchRequest: fetchRequest)
        self.content = content
    }
    
    var body: some View {
        self.content(fetchedResults)
    }
}

struct FetchRequestView_Previews: PreviewProvider {
    static var previews: some View {
        FetchRequestView(Session.fetchSessions(predicate: nil, sortDescriptors: nil), { _ in EmptyView() })
    }
}
