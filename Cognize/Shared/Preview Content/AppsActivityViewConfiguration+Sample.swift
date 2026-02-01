//
//  AppsActivityViewConfiguration+Sample.swift
//  Cognize
//
//  Created by Matvii Ustich on 01/02/2026.
//

import Foundation
import ManagedSettings

extension AppsActivityView.Configuration {
    static let sampleData: [AppsActivityView.Configuration] = [
        AppsActivityView.Configuration(
            totalUsageByApp: [Application(bundleIdentifier: "app0"): TimeInterval(15 * 60), Application(bundleIdentifier: "app1"): TimeInterval(30 * 60), Application(bundleIdentifier: "app2"): TimeInterval(55 * 60)]),
        AppsActivityView.Configuration(
            totalUsageByApp: [Application(bundleIdentifier: "app1"): TimeInterval(30 * 60)])
    ]
}
