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
        let categories = store.load()
        var totalUsageByCategory = Dictionary(uniqueKeysWithValues: categories.map { ($0.name, 0.0) })
        var otherUsage: TimeInterval = 0
        
        for await activity in data {
            for await segment in activity.activitySegments {
                for await activityCategory in segment.categories {
                    // Add usage for matching activity categories
                    for category in categories where activityCategoryIn(category: category, matches: activityCategory.category) {
                        totalUsageByCategory[category.name, default: 0] += activityCategory.totalActivityDuration
                    }
                    
                    // Add usage for matching apps
                    for await app in activityCategory.applications {
                        var matched = false
                        for category in categories where appIn(category: category, matches: app.application) {
                            totalUsageByCategory[category.name, default: 0] += app.totalActivityDuration
                            matched = true
                        }
                        if !matched {
                            otherUsage += app.totalActivityDuration
                        }
                    }
                    
//                    for await webDomain in activityCategory.webDomains {
//                        for category in categories where category.appSelection.webDomains.contains(webDomain.webDomain) {
//                            totalUsageByCategory[category.name, default: 0] += webDomain.totalActivityDuration
//                        }
//                    }
                }
            }
        }
        
        totalUsageByCategory["Other"] = otherUsage
        return CategoriesActivityView.Configuration(totalUsageByCategory: totalUsageByCategory)
    }
    
    private func appIn(category: Category, matches app: Application) -> Bool {
        category.configuration.appSelection.applications.contains { $0.token == app.token }
    }
    
    private func activityCategoryIn(category: Category, matches activityCategory: ActivityCategory) -> Bool {
        category.configuration.appSelection.categories.contains { $0.token == activityCategory.token }
    }
    
}

