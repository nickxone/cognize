//
//  CategoriesActivityView.swift
//  CognizeReportExtension
//
//  Created by Matvii Ustich on 27/07/2025.
//

import SwiftUI

struct CategoriesActivityView: View {
    struct Configuration {
        let totalUsageByCategory: [String: TimeInterval]
    }
    
    let totalActivity: Configuration
    
    var body: some View {
        DonutChartCategoriesActivityView(activity: totalActivity)
            .navigationTitle("Total Usage")
    }
}

#Preview {
//    CategoriesActivityView()
}
