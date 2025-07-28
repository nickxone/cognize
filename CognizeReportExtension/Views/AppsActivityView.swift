//
//  TotalActivityView.swift
//  CognizeReportExtension
//
//  Created by Matvii Ustich on 22/07/2025.
//

import SwiftUI
import DeviceActivity
import ManagedSettings

struct AppsActivityView: View {
    struct Configuration {
        let totalUsageByApp: [Application: TimeInterval]
    }
    
    let totalActivity: Configuration
    
    var body: some View {
        DonutChartAppsActivityView(activity: totalActivity)
    }
    
}

// In order to support previews for your extension's custom views, make sure its source files are
// members of your app's Xcode target as well as members of your extension's target. You can use
// Xcode's File Inspector to modify a file's Target Membership.
#Preview {
    //    TotalActivityView(totalActivity: "1h 23m")
}
