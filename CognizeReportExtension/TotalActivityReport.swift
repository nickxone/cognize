//
//  TotalActivityReport.swift
//  CognizeReportExtension
//
//  Created by Matvii Ustich on 22/07/2025.
//

import DeviceActivity
import SwiftUI
import ManagedSettings

struct TotalActivityReport: DeviceActivityReportScene {
    // Define which context your scene will represent.
    let context: DeviceActivityReport.Context = .totalActivity
    
    // Define the custom configuration and the resulting view for this report.
    let content: (TotalActivityView.Configuration) -> TotalActivityView
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> TotalActivityView.Configuration {
        var totalUsageByApp: [Application: TimeInterval] = [:]
        
//        Sorry about the nested for-loops 😔
//        I'll try to make it cleaner later
        for await activity in data {
            for await activitySegment in activity.activitySegments {
                for await event in activitySegment.categories {
                    for await app in event.applications {
                        totalUsageByApp[app.application] = app.totalActivityDuration
                    }
                }
            }
        }
        
        return TotalActivityView.Configuration(totalUsageByCategory: totalUsageByApp)
    }
}
