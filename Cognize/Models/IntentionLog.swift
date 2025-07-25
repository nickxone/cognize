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
    var shieldCategory: ShieldCategory
    var reason: String
    var date: Date
    var duration: Int
    
    init(shieldCategory: ShieldCategory, reason: String, date: Date = .now, duration: Int) {
        self.shieldCategory = shieldCategory
        self.reason = reason
        self.date = date
        self.duration = duration
    }
}
