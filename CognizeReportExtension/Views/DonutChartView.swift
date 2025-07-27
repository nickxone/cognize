//
//  DonutChartView.swift
//  CognizeReportExtension
//
//  Created by Matvii Ustich on 27/07/2025.
//

import SwiftUI
import Charts
import DeviceActivity
import ManagedSettings

struct AppUsage: Identifiable {
    let id = UUID()
    let appName: String
    let usage: TimeInterval
}

struct DonutChartView: View {
    let activity: TotalActivityView.Configuration
    
    var usageData: [AppUsage] {
        let sorted = activity.totalUsageByCategory
            .map { AppUsage(appName: $0.key.localizedDisplayName ?? "Unknown", usage: $0.value) }
            .sorted { $0.usage > $1.usage }
        
        let top5 = sorted.prefix(5)
        let otherUsage = sorted.dropFirst(5).reduce(0) { $0 + $1.usage }

        if otherUsage > 0 {
            return Array(top5) + [AppUsage(appName: "Other", usage: otherUsage)]
        } else {
            return Array(top5)
        }
    }
    
    var body: some View {
        VStack {
            Chart(usageData) { usage in
                SectorMark(
                    angle: .value("Usage", usage.usage),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("App", usage.appName))
            }
            .chartLegend(.visible)
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotFrame!]
                    VStack {
                        Text("Most Used App")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        Text(usageData[0].appName)
                            .font(.title2.bold())
                            .foregroundStyle(.primary)
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        .padding()
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

#Preview {
    //    DonutChartView()
}
