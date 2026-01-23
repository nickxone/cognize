//
//  OpenRestriction.swift
//  Cognize
//
//  Created by Matvii Ustich on 08/08/2025.
//

import Foundation
import DeviceActivity
import FamilyControls

struct OpenConfig: Codable, Equatable {
    var limit: Limit
    
    enum Limit: Codable, Equatable {
        case timeLimit(minutes: Int)
        case alwaysOpen
    }
}

class OpenRestriction: BaseRestriction {
    var config: OpenConfig
    
    init(categoryId: UUID, appSelection: FamilyActivitySelection, configuration: RestrictionConfiguration) {
        guard case let .open(openConfig) = configuration else {
            preconditionFailure("OpenRestriction only supports .open configuration")
        }
        self.config = openConfig
        super.init(categoryId: categoryId, appSelection: appSelection)
    }
    
}

extension OpenRestriction: RestrictionStrategy {
    func start() {
        print("Open restriction started")
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
