//
//  ShieldViewModel.swift
//  Cognize
//
//  Created by Matvii Ustich on 17/07/2025.
//

import Foundation
import ManagedSettings
import FamilyControls
import DeviceActivity

class ShieldViewModel: ObservableObject {
    @Published var entertainmentSelection = FamilyActivitySelection()
    @Published var workSelection = FamilyActivitySelection()
    
    @Published var productivityUsageThreshold = Int()
    @Published var productivityInterval = Int()
    
    private let entertainmentStore = ManagedSettingsStore(named: .entertainment)
    private let workStore = ManagedSettingsStore(named: .work)
    private let defaultStore = ManagedSettingsStore()
    
    init() {
        loadSelections()
    }
    
    // MARK: - Store Access
    private func store(for category: ShieldCategory) -> ManagedSettingsStore {
        switch category {
        case .entertainment: return entertainmentStore
        case .work: return workStore
        }
    }
    
    // MARK: - Sheilding
    private func removeShielding(for store: ManagedSettingsStore) {
        store.clearAllSettings()
    }
    
    private func selection(for category: ShieldCategory) -> FamilyActivitySelection {
        switch category {
        case .entertainment: return entertainmentSelection
        case .work: return workSelection
        }
    }
    
    func shield(_ category: ShieldCategory) {
        let selection = self.selection(for: category)
        store(for: category).shield(familyActivitySelection: selection)
    }
    
    func removeShielding(_ category: ShieldCategory) {
        store(for: category).clearAllSettings()
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
            try DeviceActivityCenter().startMonitoring(.allow, during: schedule)
            removeShielding(.entertainment)
        } catch {
            print(schedule)
            print("Error occured while unlocking activities: \(error)")
        }
    }
    
    // MARK: - Productivity Tracking
    func trackWorkActivities(thresholdUsageMinutes threshold: Int, duringIntervalMinutes interval: Int) {
        guard interval > threshold && interval >= 15  && threshold >= 1 else {
            print("Interval must be greater than threshold & interval must be greater than 15 minutes & threshold must be greater than 1 minute")
            return
        }
        
        productivityUsageThreshold = threshold
        productivityInterval = interval
        saveProductivitySettings()
        
        scheduleProductivity(name: .productivityFirst)
    }
    
    func scheduleProductivity(name: DeviceActivityName) {
        let schedule = createSchedule(
            endOffset: TimeInterval(productivityInterval * 60),
            warningTime: DateComponents(minute: productivityUsageThreshold)
        )
        
        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
            .productivityUsageThresholdEvent: DeviceActivityEvent(
                applications: workSelection.applicationTokens,
                threshold: DateComponents(minute: productivityUsageThreshold)
            )
        ]
        
        do {
            try DeviceActivityCenter().startMonitoring(name, during: schedule, events: events)
        } catch {
            print("Failed to schedule productivity event (\(name.rawValue)): \(error)")
        }
    }
    
    // MARK: - Reset
    func clearAllSettings() {
        entertainmentStore.clearAllSettings()
        workStore.clearAllSettings()
        defaultStore.clearAllSettings()
    }
    
}
