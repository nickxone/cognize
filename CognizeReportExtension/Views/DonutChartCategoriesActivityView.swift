//
//  DonutChartCategoriesActivityView.swift
//  CognizeReportExtension
//
//  Created by Matvii Ustich on 28/07/2025.
//

import SwiftUI
import Charts
import DeviceActivity
import ManagedSettings

struct DonutChartCategoriesActivityView: View {
    let activity: CategoriesActivityView.Configuration
    
    @State private var selectedEntry: TimeInterval?
    @State private var selectedApp: AppUsage?
    @State private var hideTimer: Timer?
    
    var usageData: [AppUsage] {
        let sorted = activity.totalUsageByCategory
            .map { AppUsage(appName: $0.key, usage: $0.value) }
            .sorted { $0.usage > $1.usage }
        
        return sorted
    }
    
    var body: some View {
        VStack {
            Chart(usageData) { appUsage in
                SectorMark(
                    angle: .value("Usage", appUsage.usage),
                    innerRadius: .ratio(0.618),
                    outerRadius: selectedApp?.appName == appUsage.appName ? .ratio(1.0) : .ratio(0.85),
                    angularInset: 1.5
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("App", appUsage.appName))
                .opacity(selectedApp == nil ? 1.0 : (appUsage.appName == selectedApp?.appName ? 1 : 0.3))
            }
            .chartAngleSelection(value: $selectedEntry)
            .onChange(of: selectedEntry) { oldValue, newValue in
                if let newValue {
                    withAnimation {
                        getSelectedApp(value: newValue)
                    }
                    restartHideTimer()
                }
            }
            .chartLegend(.visible)
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotFrame!]
                    VStack {
                        if let selectedApp {
                            Text("\(selectedApp.appName)")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            Text("\(formattedDuration(selectedApp.usage))")
                        } else {
                            Text("Most Used App")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            Text(usageData[0].appName)
                                .font(.title2.bold())
                                .foregroundStyle(.primary)
                        }
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        .padding()
        .navigationTitle("Total Usage")
    }
    
    private func getSelectedApp(value: TimeInterval) {
        var cumulativeTotal: TimeInterval = 0
        _ = usageData.first { appUsage in
            cumulativeTotal += appUsage.usage
            if value <= cumulativeTotal {
                selectedApp = appUsage
                return true
            }
            return false
        }
    }
    
    private func formattedDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        formatter.zeroFormattingBehavior = .dropAll
        return formatter.string(from: duration) ?? "0m"
    }
    
    private func restartHideTimer() {
        hideTimer?.invalidate()
        hideTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            withAnimation(.easeInOut(duration: 0.35)) {
                selectedApp = nil
            }
        }
    }
}


#Preview {
//    DonutChartCategoriesActivityView()
}
