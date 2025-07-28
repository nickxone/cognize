//
//  CognizeReportExtension.swift
//  CognizeReportExtension
//
//  Created by Matvii Ustich on 22/07/2025.
//

import DeviceActivity
import SwiftUI

@main
struct CognizeReportExtension: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        AppsActivityReport { totalActivity in
            AppsActivityView(totalActivity: totalActivity)
        }
        // Add more reports here...
        CategoriesActivityReport { totalActivity in
            CategoriesActivityView(totalActivity: totalActivity)
        }
    }
}
