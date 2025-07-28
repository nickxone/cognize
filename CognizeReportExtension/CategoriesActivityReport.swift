//
//  CategoriesActivityReport.swift
//  CognizeReportExtension
//
//  Created by Matvii Ustich on 27/07/2025.
//

import DeviceActivity
import SwiftUI
import ManagedSettings
import FamilyControls

struct CategoriesActivityReport: DeviceActivityReportScene {
    private let store = CategoryStore.shared
    
    // Define which context your scene will represent.
    let context: DeviceActivityReport.Context = .categoriesActivity
    
    // Define the custom configuration and the resulting view for this report.
    let content: (CategoriesActivityView.Configuration) -> CategoriesActivityView
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> CategoriesActivityView.Configuration {
        var totalUsageByCategory: [String: TimeInterval] = [:]
        let categories = store.load()
        
        for category in categories {
            totalUsageByCategory[category.name] = 0
        }
        
        var otherUsage: TimeInterval = 0
        
        for await activity in data {
            for await activitySegment in activity.activitySegments {
                for await activityCategory in activitySegment.categories {
                    
//                    for cateogoryFromAppSelection in category.appSelection.categories {
//                        if cateogoryFromAppSelection.token == activityCategory.category.token {
//                            usage += activityCategory.totalActivityDuration
//                        }
//                    }
                    
                    for await app in activityCategory.applications {
                        var appInCategoryFlag = false
                        for category in categories {
                            if appInCategory(app: app.application, category: category) {
                                totalUsageByCategory[category.name]! += app.totalActivityDuration
                                appInCategoryFlag = true
                            }
                        }
                        if !appInCategoryFlag {
                            otherUsage += app.totalActivityDuration
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
        
        totalUsageByCategory["Other"] = otherUsage
        return CategoriesActivityView.Configuration(totalUsageByCategory: totalUsageByCategory)
    }
    
    private func appInCategory(app: Application, category: Category) -> Bool {
        for activity in category.appSelection.applications {
            if app.token == activity.token {
                return true
            }
        }
        return false
    }
}

