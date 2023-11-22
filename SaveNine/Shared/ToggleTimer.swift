//
//  ToggleTimer.swift
//  SaveNine
//
//  Created by Lawrence Horne on 8/5/23.
//

import AppIntents
import SwiftData

struct ToggleTimer: LiveActivityIntent {
    static var title: LocalizedStringResource = "Toggle Timer"
    static var description = IntentDescription("Starts a live activity timer for a given project if is not running and stops it if is running.")
    
    @Parameter(title: "Project")
    var project: ProjectEntity
    
    init(project: ProjectEntity) {
        self.project = project
    }
    
    init() {}
    
    func perform() async throws -> some IntentResult {
        let modelContext = ModelContext(Persistence.container)
        let id = project.id
        let fetchDescriptor = FetchDescriptor<Project>(predicate: #Predicate { $0.id == id })
        guard let project = try! modelContext.fetch(fetchDescriptor).first else { return .result() }
        let label = project.projectSessions.first?.label
        
        if project.tracking ?? false {
            await Timer.shared.stop(for: project, label: label)
        } else {
            Timer.shared.start(for: project, date: .now, label: label)
        }
        
        try! modelContext.save()
        WidgetKind.reload(.all)
        return .result()
    }
    
    static var parameterSummary: some ParameterSummary {
            Summary("Toggle \(\.$project) timer")
        }
}
