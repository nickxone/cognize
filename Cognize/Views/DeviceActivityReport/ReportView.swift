//
//  ReportView.swift
//  Cognize
//
//  Created by Matvii Ustich on 22/07/2025.
//

import SwiftUI
import DeviceActivity



struct ReportView: View {
    @State private var context: DeviceActivityReport.Context = .totalActivity
    @State private var filter = DeviceActivityFilter(segment: .daily(during: DateInterval(start: (Calendar.current as NSCalendar).startOfDay(for: Date()), end: Date())))
    
    var body: some View {
        DeviceActivityReport(context, filter: filter)
    }
}

#Preview {
    ReportView()
}
