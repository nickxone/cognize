//
//  IntentionLog+Sample.swift
//  Cognize
//
//  Created by Matvii Ustich on 18/01/2026.
//

import Foundation

extension IntentionLog {
    static let sampleData: [IntentionLog] =
    [
        IntentionLog(category: Category.sampleData[0], reason: "Relax", date: Date.now.addingTimeInterval(-46400), duration: 30),
        IntentionLog(category: Category.sampleData[0], reason: "Have a break", date: Date.now.addingTimeInterval(-86400), duration: 10)
    ]
    
    static let sampleActiveData: [IntentionLog] =
    [
        IntentionLog(category: Category.sampleData[0], reason: "Relax", duration: 30),
        IntentionLog(category: Category.sampleData[0], reason: "Have a break", date: Date.now.addingTimeInterval(-86400), duration: 10)
    ]
}
