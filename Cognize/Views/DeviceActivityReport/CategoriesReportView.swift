//
//  CategoriesReportView.swift
//  Cognize
//
//  Created by Matvii Ustich on 27/07/2025.
//

import SwiftUI
import DeviceActivity

struct CategoriesReportView: View {
    private var thisDay: DateInterval {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        return DateInterval(start: startOfDay, end: Date())
    }
    
    @State private var context: DeviceActivityReport.Context = .categoriesActivity
    
    var body: some View {
        Group { 
            DeviceActivityReport(context)
        }
    }
}

#Preview {
    CategoriesReportView()
}
