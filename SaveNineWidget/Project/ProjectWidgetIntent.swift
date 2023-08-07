//
//  ProjectWidgetIntent.swift
//  SaveNineWidgetExtension
//
//  Created by Lawrence Horne on 8/7/23.
//

import AppIntents

struct ProjectWidgetIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Projects"
    static var description = IntentDescription("Get quick access to a project.")
    
    @Parameter(title: "Recently Tracked", default: true)
    var recentlyTracked: Bool
    
    @Parameter(title: "Project")
    var project: ProjectEntity
    
    init(recentlyTracked: Bool = true, project: ProjectEntity) {
        self.recentlyTracked = recentlyTracked
        self.project = project
    }
    
    init() {}
    
    static var parameterSummary: some ParameterSummary {
        When(\.$recentlyTracked, .equalTo, false) {
            Summary {
                \.$recentlyTracked
                \.$project
            }
        } otherwise: {
            Summary {
                \.$recentlyTracked
            }
        }
    }
}

