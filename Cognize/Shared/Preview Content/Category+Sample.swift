//
//  Category+Sample.swift
//  Cognize
//
//  Created by Matvii Ustich on 18/01/2026.
//

import Foundation
import FamilyControls

extension Category {

    static let sampleData: [Category] =
    [
        Category(name: "Games", appSelection: FamilyActivitySelection(), color: .red, configuration: .shield(.init(limit: .timeLimit(minutesAllowed: 45)))),
        Category(name: "Messengers", appSelection: FamilyActivitySelection(), color: .green, configuration: .interval(.init(thresholdTime: 2, intervalLength: 15))),
        Category(name: "Media", appSelection: FamilyActivitySelection(), color: .green, configuration: .interval(.init(thresholdTime: 4, intervalLength: 20))),
        Category(name: "Productivity", appSelection: FamilyActivitySelection(), color: .blue, configuration: .open(.init(limit: .alwaysOpen)))
    ]
}
