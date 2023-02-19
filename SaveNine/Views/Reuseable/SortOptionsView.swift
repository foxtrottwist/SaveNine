//
//  SortOptionsView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/16/23.
//

import SwiftUI

struct SortOptionsView: View {
    let sortOptions: [SortOption]
    
    @Binding var selectedSortOption: SortOption
    @Binding var selectedSortOrder: Bool
   
    init(sortOptions: [SortOption], selectedSortOption: Binding<SortOption>, selectedSortOrder: Binding<Bool>) {
        self.sortOptions = sortOptions
        
        _selectedSortOption = selectedSortOption
        _selectedSortOrder = selectedSortOrder
    }
    
    var body: some View {
        Menu {
            Picker("Sort Options", selection: $selectedSortOption) {
                ForEach(sortOptions, id: \.descriptor) { sortOption in
                    Text(sortOption.descriptor).tag(sortOption.self)
                }
            }
            
            Picker("Sort Order", selection: $selectedSortOrder) {
                Text(selectedSortOption.orderAscending.descriptor)
                    .tag(selectedSortOption.orderAscending.value)
                
                Text(selectedSortOption.orderDescending.descriptor)
                    .tag(selectedSortOption.orderDescending.value)
            }
        }  label: {
            Label("Sort By", systemImage: "arrow.up.arrow.down")
        }
    }
}

struct SortOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        SortOptionsView(
            sortOptions: [.creationDate, .name],
            selectedSortOption: .constant(.creationDate),
            selectedSortOrder: .constant(Bool())
        )
    }
}
