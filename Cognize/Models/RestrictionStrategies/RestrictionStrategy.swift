//
//  RestrictionStrategy.swift
//  Cognize
//
//  Created by Matvii Ustich on 25/07/2025.
//

import Foundation

protocol RestrictionStrategy: Codable {
    func intervalDidStart()
    func intervalDidEnd()
    func eventDidReachThreshold()
    func intervalWillStartWarning()
    func intervalWillEndWarning()
    func eventWillReachThresholdWarning()
}
