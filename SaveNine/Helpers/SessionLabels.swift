//
//  SessionLabels.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/11/23.
//

import Foundation

final class SessionLabels: ObservableObject {
    @Published var labels = [SessionLabel]()
    
    let url = URL.documentsDirectory.appending(path: appendFileExtension(to: "sessionLabels", using: .json))
    
    init() {
        guard FileManager.default.fileExists(atPath: url.path()) else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        
        if let labels = try? JSONDecoder().decode([SessionLabel].self, from: data) {
            self.labels = labels
        }
    }
    
    func add(label: SessionLabel) {
        guard !labels.contains(where: { $0.name.lowercased() == label.name.lowercased() }) else { return }
        labels.append(label)
    }
    
    func get(_ id: UUID) -> SessionLabel? {
        return labels.first(where: { $0.id == id })
    }
    
    func remove(label: SessionLabel) {
        labels.removeAll(where: { $0.id == label.id })
    }
    
    func removeAll() {
        labels.removeAll()
    }
    
    func save() {
        let data = try? JSONEncoder().encode(labels)
        try? data?.write(to: url)
    }
}
