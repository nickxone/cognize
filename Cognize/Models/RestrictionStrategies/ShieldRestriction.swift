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

class ShieldRestriction: RestrictionStrategy, Codable {
    let categoryName: String
    let categoryId: UUID
    let appSelection: FamilyActivitySelection
    
    init(categoryName: String, categoryId: UUID, appSelection: FamilyActivitySelection) {
        self.categoryName = categoryName
        self.categoryId = categoryId
        self.appSelection = appSelection
    }
    
    private var storeName: ManagedSettingsStore.Name {
        .init("store-\(categoryId.uuidString)")
    }
    
    private var deviceActivityName: DeviceActivityName {
        .init("allow-\(categoryId.uuidString)")
    }
    
    private func removeShielding() {
        let store = ManagedSettingsStore(named: storeName)
        store.clearAllSettings()
    }
    
    func shield() {
        let store = ManagedSettingsStore(named: storeName)
        store.shield(familyActivitySelection: appSelection)
    }
    
    // MARK: - Scheduling
    private func makeInterval(startOffset: TimeInterval = 0, endOffset: TimeInterval) -> (DateComponents, DateComponents) {
        let now = Date().addingTimeInterval(startOffset)
        let end = Date().addingTimeInterval(endOffset)
        let calendar = Calendar.current
        return (
            calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now),
            calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: end)
        )
    }
    
    private func createSchedule(startOffset: TimeInterval = 0, endOffset: TimeInterval, warningTime: DateComponents? = nil) -> DeviceActivitySchedule {
        let (start, end) = makeInterval(startOffset: startOffset, endOffset: endOffset)
        return DeviceActivitySchedule(intervalStart: start, intervalEnd: end, repeats: false, warningTime: warningTime)
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
    
    func intervalDidStart() {
        print("\(categoryName) intervalDidStart")
    }
    
    func intervalDidEnd() {
        NotificationManager.shared.scheduleNotification(title: "End schedule", body: "Ended \(categoryName)", inSeconds: 1.5)
        shield()
    }
    
    func eventDidReachThreshold() {
        print("\(categoryName) eventDidReachThreshold")
    }
    
    func intervalWillStartWarning() {
        print("\(categoryId) intervalWillStartWarning ")
    }
    
    func intervalWillEndWarning() {
        NotificationManager.shared.scheduleNotification(title: "Cognize", body: "Apps are about to relock", inSeconds: 1.5)
    }
    
    func eventWillReachThresholdWarning() {
        print("\(categoryName) eventWillReachThresholdWarning")
    }
    
    
}
