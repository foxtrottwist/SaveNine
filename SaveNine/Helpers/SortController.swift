//
//  SortController.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/18/23.
//

import Combine
import Foundation

final class SortController: ObservableObject, Codable {
    @Published var sortAscending: Bool
    @Published var sortOption: SortOption
    
    init(defaultSort: SortOption, sortAscending: Bool) {
        self.sortOption = defaultSort
        self.sortAscending = sortAscending
    }
    
    enum CodingKeys: String, CodingKey {
       case sortOption, sortAscending
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sortAscending, forKey: .sortAscending)
        try container.encode(sortOption, forKey: .sortOption)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sortAscending = try container.decode(Bool.self, forKey: .sortAscending)
        sortOption = try container.decode(SortOption.self, forKey: .sortOption)
    }
    
    var jsonData: Data? {
        get {
            try? JSONEncoder().encode(self)
        }
        
        set {
            guard let data = newValue, let model = try? JSONDecoder().decode(SortController.self, from: data) else { return }
            sortAscending = model.sortAscending
            sortOption = model.sortOption
        }
    }
    
    var objectWillChangeSequence:
            AsyncPublisher<Publishers.Buffer<ObservableObjectPublisher>>
        {
            objectWillChange
                .buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
                .values
        }
}

