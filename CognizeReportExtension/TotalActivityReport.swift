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
        var totalUsageByCategory: [ActivityCategory: TimeInterval] = [:]
//        totalUsageByCategory = data.map( /*do smth*/)
        
        for await activity in data {
            for await activitySegment in activity.activitySegments {
                for await event in activitySegment.categories {
                    totalUsageByCategory[event.category] = event.totalActivityDuration
                }
            }
        }
        return TotalActivityView.Configuration(totalUsageByCategory: totalUsageByCategory)
    }
}
