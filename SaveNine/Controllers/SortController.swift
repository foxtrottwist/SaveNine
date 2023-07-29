//
//  SortController.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/18/23.
//

import Combine
import Foundation
import Observation

@Observable
final class SortController: Codable {
    var sortAscending: Bool
    var sortOption: SortOption
    
    private var listView = ""
    
    init(for listView: String, defaultSort: SortOption, sortAscending: Bool) {
        self.listView = listView
        let url = URL.documentsDirectory.appending(path: FileExtension.append(to: listView, using: .json))
        
        if FileManager.default.fileExists(atPath: url.path()),
           let data = try? Data(contentsOf: url),
           let model = try? JSONDecoder().decode(SortController.self, from: data) {
            self.sortAscending = model.sortAscending
            self.sortOption = model.sortOption
        } else {
            self.sortOption = defaultSort
            self.sortAscending = sortAscending
        }
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
    
    func save() {
        let url = URL.documentsDirectory.appending(path: FileExtension.append(to: listView, using: .json))
        let data = try? JSONEncoder().encode(self)
        try? data?.write(to: url)
    }
}

