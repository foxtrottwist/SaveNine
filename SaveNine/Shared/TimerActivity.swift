//
//  TimerActivity.swift
//  SaveNine
//
//  Created by Lawrence Horne on 8/6/23.
//

import ActivityKit
import Foundation
import OSLog


final class TimerActivity {
    static let shared = TimerActivity()
    var liveActivity: Activity<TimerAttributes>?
    
    func endLiveActivity(date: Date = Date()) async {
        for activity in Activity<TimerAttributes>.activities {
            await activity.end(ActivityContent(state: TimerAttributes.ContentState(start: date), staleDate: nil), dismissalPolicy: .immediate)
        }
    }
    
    func requestLiveActivity(project: Project, date: Date) {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            let attributes = TimerAttributes(projectName: project.name, projectId: project.id!)
            let contentState = ActivityContent(state: TimerAttributes.ContentState(start: date), staleDate: nil)
            
            do {
                 liveActivity = try Activity.request(attributes: attributes, content: contentState)
            } catch {
                Logger.statistics.error("\(Self.self) – \(error.localizedDescription)")
            }
        }
    }
    
    func updateLiveActivity(date: Date?) async {
        if let date {
            await liveActivity?.update(ActivityContent(state: TimerAttributes.ContentState(start: date), staleDate: nil))
        }
    }
}
