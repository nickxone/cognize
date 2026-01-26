//
//  IntentionLog.swift
//  Cognize
//
//  Created by Matvii Ustich on 23/07/2025.
//

import Foundation
import SwiftData

@Model
class IntentionLog: Identifiable {
    var id: UUID
    var categoryId: UUID
    var reason: String
    var startDate: Date
    var duration: TimeInterval
    
    init(id: UUID = UUID(), category: Category, reason: String, date: Date = .now, duration: TimeInterval) {
        self.id = id
        self.categoryId = category.id
        self.reason = reason
        self.startDate = date
        self.duration = duration
    }
}

extension IntentionLog {
    var endDate: Date {
        startDate.addingTimeInterval(duration)
    }
    
    var isActive: Bool {
        let now = Date()
        return now >= startDate && now < endDate
    }
    
//    var timeLeft: TimeInterval {
//        let remaining = endDate.timeIntervalSince(Date())
//        return max(0, remaining)
//    }
}
