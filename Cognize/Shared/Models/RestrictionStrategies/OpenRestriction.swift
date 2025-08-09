//
//  OpenRestriction.swift
//  Cognize
//
//  Created by Matvii Ustich on 08/08/2025.
//

import DeviceActivity
import FamilyControls

struct OpenConfig: Codable, Equatable {
    var appSelection: FamilyActivitySelection
    var limit: Limit
    
    enum Limit: Codable, Equatable {
        case timeLimit(minutes: Int)
        case alwaysOpen
    }

}

class OpenRestriction: BaseRestriction, RestrictionStrategy {
    
    func intervalDidStart(for activity: DeviceActivityName) {
        // TODO: Implement
    }
    
    func intervalDidEnd(for activity: DeviceActivityName) {
        // TODO: Implement
    }
    
    func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, for activity: DeviceActivityName) {
        // TODO: Implement
    }
    
    func intervalWillStartWarning(for activity: DeviceActivityName) {
        // TODO: Implement
    }
    
    func intervalWillEndWarning(for activity: DeviceActivityName) {
        // TODO: Implement
    }
    
    func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, for activity: DeviceActivityName) {
        // TODO: Implement
    }
    
    
}
