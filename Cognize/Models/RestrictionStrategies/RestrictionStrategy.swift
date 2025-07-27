//
//  RestrictionStrategy.swift
//  Cognize
//
//  Created by Matvii Ustich on 25/07/2025.
//

import Foundation
import DeviceActivity

protocol RestrictionStrategy {
    func intervalDidStart(for activity: DeviceActivityName)
    func intervalDidEnd(for activity: DeviceActivityName)
    func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, for activity: DeviceActivityName)
    func intervalWillStartWarning(for activity: DeviceActivityName)
    func intervalWillEndWarning(for activity: DeviceActivityName)
    func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, for activity: DeviceActivityName)
}
