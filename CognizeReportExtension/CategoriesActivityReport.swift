//
//  CategoriesActivityReport.swift
//  CognizeReportExtension
//
//  Created by Matvii Ustich on 27/07/2025.
//

import DeviceActivity
import SwiftUI
import ManagedSettings

struct CategoriesActivityReport: DeviceActivityReportScene {
    private let store = CategoryStore.shared
    
    // Define which context your scene will represent.
    let context: DeviceActivityReport.Context = .categoriesActivity
    
    // Define the custom configuration and the resulting view for this report.
    let content: (CategoriesActivityView.Configuration) -> CategoriesActivityView
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> CategoriesActivityView.Configuration {
        var totalUsageByCategory: [String: TimeInterval] = [:]
        let categories = store.load()
        
//        Sorry about the nested for-loops 😔
//        I'll try to make it cleaner later
        var otherUsage: TimeInterval = 0
        for category in categories {
            var usage: TimeInterval = 0
            
            for await activity in data {
                for await activitySegment in activity.activitySegments {
                    for await activityCategory in activitySegment.categories {
                        
                        for cateogoryFromAppSelection in category.appSelection.categories {
                            if cateogoryFromAppSelection.token == activityCategory.category.token {
                                usage += activityCategory.totalActivityDuration
                            }
                        }

                        for await app in activityCategory.applications {
                            for appFromAppSelection in category.appSelection.applications {
                                if appFromAppSelection.token == app.application.token {
                                    usage += app.totalActivityDuration
                                } else {
                                    otherUsage += app.totalActivityDuration
                                }
                            }
                        }
                        
//                        for await webDomain in activityCategory.webDomains {
//                            if category.appSelection.webDomains.contains(webDomain.webDomain) {
//                                usage += webDomain.totalActivityDuration
//                            }
//                        }
                    }
                }
            }
            totalUsageByCategory[category.name] = usage
        }
        
        totalUsageByCategory["Other"] = otherUsage
        return CategoriesActivityView.Configuration(totalUsageByCategory: totalUsageByCategory)
    }
}

