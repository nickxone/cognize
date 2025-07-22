//
//  TotalActivityView.swift
//  CognizeReportExtension
//
//  Created by Matvii Ustich on 22/07/2025.
//

import SwiftUI
import DeviceActivity
import ManagedSettings

struct TotalActivityView: View {
    struct Configuration {
        let totalUsageByCategory: [ActivityCategory: TimeInterval]
    }

    let totalActivity: Configuration

    var body: some View {
        List {
            ForEach(totalActivity.totalUsageByCategory.sorted(by: { $0.value > $1.value }), id: \.key) { category, duration in
                HStack {
                    Text(category.localizedDisplayName ?? "Unknown")
                    Spacer()
                    Text(formattedDuration(duration))
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("Total Usage")
    }

    func formattedDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        formatter.zeroFormattingBehavior = .dropAll
        return formatter.string(from: duration) ?? "0m"
    }
}

// In order to support previews for your extension's custom views, make sure its source files are
// members of your app's Xcode target as well as members of your extension's target. You can use
// Xcode's File Inspector to modify a file's Target Membership.
#Preview {
    //    TotalActivityView(totalActivity: "1h 23m")
}
