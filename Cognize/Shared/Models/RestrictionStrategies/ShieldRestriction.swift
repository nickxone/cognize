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

class ShieldRestriction: BaseRestriction, RestrictionStrategy {
    
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
    
//    MARK: - RestrictionStrategy Implementation
    func intervalDidStart(for activity: DeviceActivityName) {
        print("\(categoryName) intervalDidStart")
    }
    
    func intervalDidEnd(for activity: DeviceActivityName) {
        NotificationManager.shared.scheduleNotification(title: "End schedule", body: "Ended \(categoryName)", inSeconds: 1.5)
        shield()
    }
    
    func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, for activity: DeviceActivityName) {
        print("\(categoryName) eventDidReachThreshold")
    }
    
    func intervalWillStartWarning(for activity: DeviceActivityName) {
        print("\(categoryId) intervalWillStartWarning ")
    }
    
    func intervalWillEndWarning(for activity: DeviceActivityName) {
        NotificationManager.shared.scheduleNotification(title: "Cognize", body: "Apps are about to relock", inSeconds: 1.5)
    }
    
    func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, for activity: DeviceActivityName) {
        print("\(categoryName) eventWillReachThresholdWarning")
    }
}
