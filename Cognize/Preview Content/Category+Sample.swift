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
        Category(name: "Social", appSelection: FamilyActivitySelection(), color: .green, configuration: .interval(.init(thresholdTime: 2, intervalLength: 15)))
    ]
}
