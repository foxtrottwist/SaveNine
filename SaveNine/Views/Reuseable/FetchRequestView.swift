//
//  FetchRequestView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 11/8/22.
//

import SwiftData
import SwiftUI

struct FetchRequestView<T: PersistentModel, Content: View>: View {
    @Query private var queryResult: [T]
    
    let content: ([T]) -> Content
    
    init(_ fetchDescriptor: FetchDescriptor<T>, @ViewBuilder _ content: @escaping ([T]) -> Content) {
        _queryResult = Query(fetchDescriptor, animation: .snappy)
        self.content = content
    }
    
    var body: some View {
        self.content(queryResult)
    }
}

struct FetchRequestView_Previews: PreviewProvider {
    static var previews: some View {
        FetchRequestView<Project, EmptyView>(FetchDescriptor(), { _ in EmptyView() })
            .modelContainer(for: [Project.self, Session.self, Tag.self], inMemory: true)
    }
}
