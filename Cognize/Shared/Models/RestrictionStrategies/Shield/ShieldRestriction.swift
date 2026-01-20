//
//  ShieldRestriction.swift
//  Cognize
//
//  Created by Matvii Ustich on 25/07/2025.
//

import Foundation
import ManagedSettings
import FamilyControls
import DeviceActivity

struct ShieldConfig: Codable, Equatable {
    var limit: Limit
    
    enum Limit: Codable, Equatable {
        case timeLimit(minutesAllowed: Int)
        case openLimit(opensAllowed: Int, minutesPerOpen: Int)
    }    
}

class ShieldRestriction: BaseRestriction {
    var config: ShieldConfig
    
    init(categoryId: UUID, appSelection: FamilyActivitySelection, configuration: RestrictionConfiguration) {
        guard case let .shield(shieldConfig) = configuration else {
            preconditionFailure("ShieldRestriction requires a .shield conguration")
        }
        self.config = shieldConfig
        super.init(categoryId: categoryId, appSelection: appSelection)
    }
    
    
    private var deviceActivityName: DeviceActivityName {
        .init("allow-\(categoryId.uuidString)")
    }
    
    // MARK: - Unlocking
    func unlockEntertainmentActivities(for minutes: Int) {
        guard minutes >= 1 else {
            print("Unlock duration must be at least 1 minute")
            return
        }
        
        let schedule = createSchedule(
            startOffset: -15 * 60, // 15 minutes in the past
            endOffset: TimeInterval(minutes * 60),
            warningTime: DateComponents(second: 30)
        )
        
        do {
            try DeviceActivityCenter().startMonitoring(deviceActivityName, during: schedule)
            removeShielding()
        } catch {
            print(schedule)
            print("Error occured while unlocking activities: \(error)")
        }
    }
    
}

extension ShieldRestriction: RestrictionStrategy {
    func start() {
        shield()
    }
    
    func intervalDidStart(for activity: DeviceActivityName) {
    }
    
    func intervalDidEnd(for activity: DeviceActivityName) {
        NotificationManager.shared.scheduleNotification(title: "End schedule", body: "Ended ", inSeconds: 1.5)
        shield()
    }
    
    func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, for activity: DeviceActivityName) {
    }
    
    func intervalWillStartWarning(for activity: DeviceActivityName) {
        print("\(categoryId) intervalWillStartWarning ")
    }
    
    func intervalWillEndWarning(for activity: DeviceActivityName) {
        NotificationManager.shared.scheduleNotification(title: "Cognize", body: "Apps are about to relock", inSeconds: 1.5)
    }
    
    func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, for activity: DeviceActivityName) {
    }
}
