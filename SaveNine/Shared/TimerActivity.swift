//
//  TimerActivity.swift
//  SaveNine
//
//  Created by Lawrence Horne on 8/6/23.
//

import ActivityKit
import Foundation


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
            let attributes = TimerAttributes(projectName: project.displayName, projectId: project.id!)
            let contentState = ActivityContent(state: TimerAttributes.ContentState(start: date), staleDate: nil)
            
            do {
                try liveActivity = Activity.request(attributes: attributes, content: contentState)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateLiveActivity(date: Date?) async {
        if let date {
            await liveActivity?.update(ActivityContent(state: TimerAttributes.ContentState(start: date), staleDate: nil))
        }
    }
}
