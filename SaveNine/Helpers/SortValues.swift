//
//  SortValues.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/18/23.
//

import Foundation
import Observation

@Observable
final class SortValues: Codable {
    var sortOption: SortOption = .endDate
    var sortOrder: SortOrder = .reverse
    
    enum CodingKeys: String, CodingKey {
        case sortBy, sortOrder
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sortOption, forKey: .sortBy)
        try container.encode(sortOrder, forKey: .sortOrder)
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sortOption = try container.decode(SortOption.self, forKey: .sortBy)
        sortOrder = try container.decode(SortOrder.self, forKey: .sortOrder)
    }
    
    var data: Data? {
        get {
            try? JSONEncoder().encode(self)
        }
        set {
            if let data = newValue, let options = try? JSONDecoder().decode(SortValues.self, from: data) {
                self.sortOption = options.sortOption
                self.sortOrder = options.sortOrder
            }
        }
    }
}

