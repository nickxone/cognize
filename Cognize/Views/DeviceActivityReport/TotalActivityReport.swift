//
//  MyReportContext.swift
//  Cognize
//
//  Created by Matvii Ustich on 22/07/2025.
//

import Foundation
import SwiftUI
import DeviceActivity

extension DeviceActivityReport.Context {
    static let totalActivity: DeviceActivityReport.Context = Self("totalActivity")
    
}

struct TotalActivityReportContext: DeviceActivityReportScene {
    let context: DeviceActivityReport.Context = .totalActivity
    let content: (String) -> TotalActivityView
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> String {
        "Test"
    }
}
