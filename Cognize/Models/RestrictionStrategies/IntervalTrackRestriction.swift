//
//  IntervalTrackRestriction.swift
//  Cognize
//
//  Created by Matvii Ustich on 25/07/2025.
//

import Foundation
import ManagedSettings
import FamilyControls
import DeviceActivity

class IntervalTrackRestriction: RestrictionStrategy {
    let categoryName: String
    let categoryId: UUID
    let appSelection: FamilyActivitySelection
    
    var productivityUsageThreshold = Int()
    var productivityInterval = Int()
    
    init(categoryName: String, categoryId: UUID, appSelection: FamilyActivitySelection) {
        self.categoryName = categoryName
        self.categoryId = categoryId
        self.appSelection = appSelection
        
        loadSelections()
    }
    
    private var storeName: ManagedSettingsStore.Name {
        .init("store-\(categoryId.uuidString)")
    }
    
    private var deviceActivityNameFirst: DeviceActivityName {
        .init("first-\(categoryId.uuidString)")
    }
    
    private var deviceActivityNameSecond: DeviceActivityName {
        .init("second-\(categoryId.uuidString)")
    }
    
    private var deviceActivityEventName: DeviceActivityEvent.Name {
        .init("event-\(categoryId.uuidString)")
    }
    
    func loadSelections() {
        let defaults = UserDefaults(suiteName: "group.com.app.cognize") ?? .standard
        if let pThreshold = loadCodable(Int.self, forKey: "productivityUsageThreshold-\(categoryId.uuidString)", from: defaults) {
            productivityUsageThreshold = pThreshold
        }
        if let pInterval = loadCodable(Int.self, forKey: "productivityInterval-\(categoryId.uuidString)", from: defaults) {
            productivityInterval = pInterval
        }
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
    
    func scheduleProductivity(name: DeviceActivityName) {
        let schedule = createSchedule(
            endOffset: TimeInterval(productivityInterval * 60),
            warningTime: DateComponents(minute: productivityUsageThreshold)
        )
        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
            deviceActivityEventName: DeviceActivityEvent(
                applications: appSelection.applicationTokens, // potential source of errors in case appSelection contains categoryTokens rather than applicationTokens
                categories: appSelection.categoryTokens,
                webDomains: appSelection.webDomainTokens,
                threshold: DateComponents(minute: productivityUsageThreshold)
            )
        ]
        
        do {
            try DeviceActivityCenter().startMonitoring(name, during: schedule, events: events)
            print("Start monitoring: \(name) \(schedule) \(events)")
        } catch {
            print("Failed to schedule productivity event (\(name.rawValue)): \(error)")
        }
    }
    
    func track(thresholdUsageMinutes threshold: Int, duringIntervalMinutes interval: Int) {
        guard interval > threshold && interval >= 15  && threshold >= 1 else {
            print("Interval must be greater than threshold & interval must be greater than 15 minutes & threshold must be greater than 1 minute")
            return
        }
        
        productivityUsageThreshold = threshold
        productivityInterval = interval
        saveProductivitySettings()
        
        scheduleProductivity(name: deviceActivityNameFirst)
        NotificationManager.shared.scheduleNotification(title: "track", body: "\(threshold) \(interval)", inSeconds: 1.5)
    }
    
    private func saveCodable<T: Codable>(_ value: T, forKey key: String, in defaults: UserDefaults) {
        if let data = try? JSONEncoder().encode(value) {
            defaults.set(data, forKey: key)
        }
    }
    
    private func loadCodable<T: Codable>(_ type: T.Type, forKey key: String, from defaults: UserDefaults) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
    
    func saveProductivitySettings() {
        let defaults = UserDefaults(suiteName: "group.com.app.cognize") ?? .standard
        saveCodable(productivityUsageThreshold, forKey: "productivityUsageThreshold-\(categoryId.uuidString)", in: defaults)
        saveCodable(productivityInterval, forKey: "productivityInterval-\(categoryId.uuidString)", in: defaults)
    }
    
    //    MARK: - RestrictionStrategy Implementation
    func shield() {
        let store = ManagedSettingsStore(named: storeName)
        store.shield(familyActivitySelection: appSelection)
    }
    
    func intervalDidStart(for activity: DeviceActivityName) {
        print("\(categoryName) intervalDidStart")
        NotificationManager.shared.scheduleNotification(title: "intervalDidStart", body: "\(activity.rawValue)", inSeconds: 1.5)
    }
    
    func intervalDidEnd(for activity: DeviceActivityName) {
        print("\(categoryName) intervalDidEnd")
        NotificationManager.shared.scheduleNotification(title: "intervalDidEnd", body: "\(activity.rawValue)", inSeconds: 1.5)
    }
    
    func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, for activity: DeviceActivityName) {
        if event == deviceActivityEventName {
            shield()
            NotificationManager.shared.scheduleNotification(title: "Log your intention", body: "\(event.rawValue) \(activity.rawValue)", inSeconds: 1.5)
        }
    }
    
    func intervalWillStartWarning(for activity: DeviceActivityName) {
        print("\(categoryName) intervalWillStartWarning")
        NotificationManager.shared.scheduleNotification(title: "intervalWillStartWarning", body: "\(activity.rawValue)", inSeconds: 1.5)
    }
    
    func intervalWillEndWarning(for activity: DeviceActivityName) {
        if activity == deviceActivityNameFirst {
            // schedule second
            scheduleProductivity(name: deviceActivityNameSecond)
        } else if activity == deviceActivityNameSecond {
            // schedule first otherwise
            scheduleProductivity(name: deviceActivityNameFirst)
        }
    }
    
    func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, for activity: DeviceActivityName) {
        print("\(categoryName) eventWillReachThresholdWarning")
        NotificationManager.shared.scheduleNotification(title: "eventWillReachThresholdWarning", body: "\(event.rawValue) \(activity.rawValue)", inSeconds: 1.5)
    }
    
    
}
