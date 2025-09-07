//
//  IntentionLog.swift
//  Cognize
//
//  Created by Matvii Ustich on 23/07/2025.
//

import Foundation
import SwiftData

@Model
class IntentionLog {
    var categoryId: UUID
    var reason: String
    var date: Date
    var duration: Int
    
    init(category: Category, reason: String, date: Date = .now, duration: Int) {
        self.categoryId = category.id
        self.reason = reason
        self.date = date
        self.duration = duration
    }
}
