//
//  SortOptionsView.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/16/23.
//

import SwiftUI

struct SortOptionsView: View {
    let options: [SortOption]
    
    @Binding var selectedSortOption: SortOption
    @Binding var selectedSortOrder: Bool
   
    init(options: [SortOption], sortOption: Binding<SortOption>, sortOrder: Binding<Bool>) {
        self.options = options
        
        _selectedSortOption = sortOption
        _selectedSortOrder = sortOrder
    }
    
    var body: some View {
        Menu {
            Picker("Sort Options", selection: $selectedSortOption) {
                ForEach(options, id: \.descriptor) { option in
                    Text(option.descriptor).tag(option.self)
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
        SortOptionsView(options: [.creationDate, .name], sortOption: .constant(.creationDate), sortOrder: .constant(Bool()))
    }
}
