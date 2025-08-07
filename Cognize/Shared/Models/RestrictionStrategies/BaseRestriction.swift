//
//  BaseRestriction.swift
//  Cognize
//
//  Created by Matvii Ustich on 27/07/2025.
//

import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity

class BaseRestriction: Codable {
    let categoryId: UUID
    let appSelection: FamilyActivitySelection
    
    init(categoryId: UUID, appSelection: FamilyActivitySelection) {
        self.categoryId = categoryId
        self.appSelection = appSelection
    }
    
    var storeName: ManagedSettingsStore.Name {
        .init("store-\(categoryId.uuidString)")
    }
    
    // MARK: - Shielding
    func removeShielding() {
        let store = ManagedSettingsStore(named: storeName)
        store.clearAllSettings()
    }
    
    func shield() {
        let store = ManagedSettingsStore(named: storeName)
        store.shield(familyActivitySelection: appSelection)
    }
    
    // MARK: - Scheduling
    func makeInterval(startOffset: TimeInterval = 0, endOffset: TimeInterval) -> (DateComponents, DateComponents) {
        let now = Date().addingTimeInterval(startOffset)
        let end = Date().addingTimeInterval(endOffset)
        let calendar = Calendar.current
        return (
            calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now),
            calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: end)
        )
    }
    
    func createSchedule(startOffset: TimeInterval = 0, endOffset: TimeInterval, warningTime: DateComponents? = nil) -> DeviceActivitySchedule {
        let (start, end) = makeInterval(startOffset: startOffset, endOffset: endOffset)
        return DeviceActivitySchedule(intervalStart: start, intervalEnd: end, repeats: false, warningTime: warningTime)
    }
    
}
