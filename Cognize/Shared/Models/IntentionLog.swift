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
    var date: Date
    var duration: Int
    
    init(id: UUID = UUID(), category: Category, reason: String, date: Date = .now, duration: Int) {
        self.id = id
        self.categoryId = category.id
        self.reason = reason
        self.date = date
        self.duration = duration
    }
}

extension IntentionLog {
    var endDate: Date {
        date.addingTimeInterval(TimeInterval(duration * 60))
    }
    
    var isActive: Bool {
        let now = Date()
        return now >= date && now < endDate
    }
    
    var timeLeft: TimeInterval {
        let remaining = endDate.timeIntervalSince(Date())
        return max(0, remaining)
    }
}
