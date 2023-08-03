//
//  SessionLabelController.swift
//  SaveNine
//
//  Created by Lawrence Horne on 2/11/23.
//

import Foundation
import Observation

@Observable
final class SessionLabelController {
    var labels = [SessionLabel]()
    
    private let url = URL.documentsDirectory.appending(path: FileExtension.append(to: "sessionLabels", using: .json))
    
    init() {
        guard FileManager.default.fileExists(atPath: url.path()) else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        
        if let labels = try? JSONDecoder().decode([SessionLabel].self, from: data) {
            self.labels = labels
        }
    }
    
    static var preview: SessionLabelController = {
        let sessionLabelController = SessionLabelController()
        sessionLabelController.labels = SessionLabel.Examples
        return sessionLabelController
    }()
    
    func add(name: String) {
        let name = name.trimmingCharacters(in: .whitespaces)
        let test = name.lowercased()
        
        if test.isEmpty
            || test == DefaultLabel.addLabel.rawValue.lowercased()
            || test == DefaultLabel.none.rawValue.lowercased()
            || labels.contains(where: { $0.name.lowercased() == test }) { return }
        
        labels.append(.init(id: UUID(), name: name, lastUsed: Date()))
        labels = labels.sorted(using: KeyPathComparator(\.name))
        save()
    }
    
    func get(_ id: UUID) -> SessionLabel? {
        return labels.first(where: { $0.id == id })
    }
    
    func remove(label: SessionLabel) {
        labels.removeAll(where: { $0.id == label.id })
        save()
    }
    
    func removeAll() {
        labels.removeAll()
        save()
    }
    
    func save() {
        let data = try? JSONEncoder().encode(labels)
        try? data?.write(to: url)
    }
}

struct SessionLabel: Codable, Identifiable {
    let id: UUID
    let name: String
    let lastUsed: Date
    
    static var Example: SessionLabel {
        .init(id: UUID(), name: "Quilting", lastUsed: Date())
    }
    
    static var Examples: [SessionLabel] {
        [
            .init(id: UUID(), name: "Cutting", lastUsed: Date()),
            .init(id: UUID(), name: "Designing", lastUsed: Date()),
            .init(id: UUID(), name: "Influencing", lastUsed: Date()),
            .init(id: UUID(), name: "Quilting", lastUsed: Date()),
        ]
    }
}
