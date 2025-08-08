//
//  OpenRestriction.swift
//  Cognize
//
//  Created by Matvii Ustich on 08/08/2025.
//

import DeviceActivity
import FamilyControls

class OpenRestriction: BaseRestriction, RestrictionStrategy {
    enum Configuration: Codable, Equatable {
        case alwaysOpen(AlwaysOpen)
        case timeLimit(TimeLimit)
        
        struct AlwaysOpen: Codable, Equatable {
            var appSelection: FamilyActivitySelection
        }
        
        struct TimeLimit: Codable, Equatable {
            var appSelection: FamilyActivitySelection
            var timeLimit: Int
        }
        
        var appSelection: FamilyActivitySelection {
            switch self {
            case .alwaysOpen(let config):
                return config.appSelection
            case .timeLimit(let config):
                return config.appSelection
            }
        }
    }
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
