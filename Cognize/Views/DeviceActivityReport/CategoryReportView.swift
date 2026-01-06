//
//  ReportView.swift
//  Cognize
//
//  Created by Matvii Ustich on 22/07/2025.
//

import SwiftUI
import DeviceActivity

struct CategoryReportView: View {
    var category: Category
    
    private var thisDay: DateInterval {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        return DateInterval(start: startOfDay, end: Date())
    }
    
    @State private var context: DeviceActivityReport.Context = .appsActivity
    @State private var filter: DeviceActivityFilter?
    
    var body: some View {
        Group {
            if let filter {
                DeviceActivityReport(context, filter: filter)
                    .onAppear {
//                        print("Appeared")
                    }
            } else {
                Text("Loading")
            }
        }
        .onAppear {
            withAnimation {
                filter = DeviceActivityFilter(segment: .daily(during: thisDay), applications: category.appSelection.applicationTokens, categories: category.appSelection.categoryTokens, webDomains: category.appSelection.webDomainTokens)
            }
        }
    }
}

#Preview {
    //    ReportView()
}
