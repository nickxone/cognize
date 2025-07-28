//
//  TotalActivityReport.swift
//  CognizeReportExtension
//
//  Created by Matvii Ustich on 22/07/2025.
//

import DeviceActivity
import SwiftUI
import ManagedSettings

struct AppsActivityReport: DeviceActivityReportScene {
    // Define which context your scene will represent.
    let context: DeviceActivityReport.Context = .appsActivity
    
    // Define the custom configuration and the resulting view for this report.
    let content: (AppsActivityView.Configuration) -> AppsActivityView
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> AppsActivityView.Configuration {
        var totalUsageByApp: [Application: TimeInterval] = [:]
        
//        Sorry about the nested for-loops 😔
//        I'll try to make it cleaner later
        for await activity in data {
            for await activitySegment in activity.activitySegments {
                for await activityCategory in activitySegment.categories {
                    // To-Do include web categories as well
                    for await app in activityCategory.applications {
                        totalUsageByApp[app.application] = app.totalActivityDuration
                    }
                }
            }
        }
        
        return AppsActivityView.Configuration(totalUsageByApp: totalUsageByApp)
    }
}
