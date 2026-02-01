//
//  CategoriesActivityViewConfiguration+Sample.swift
//  Cognize
//
//  Created by Matvii Ustich on 01/02/2026.
//

import Foundation

extension CategoriesActivityView.Configuration {
    static let sampleData: [CategoriesActivityView.Configuration] = [
        CategoriesActivityView.Configuration(totalUsageByCategory: [Category.sampleData[0].name: TimeInterval(15 * 60),
                                                                    Category.sampleData[1].name: TimeInterval(35 * 60),
                                                                    Category.sampleData[2].name: TimeInterval(45 * 60),
                                                                    Category.sampleData[3].name: TimeInterval(50 * 60)])
    ]
}
