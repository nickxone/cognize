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
    
    private func removeShielding(for store: ManagedSettingsStore) {
        store.clearAllSettings()
    }
    
    func shieldEntertainment() {
        entertainmentStore.shield(familyActivitySelection: entertainmentSelection)
    }
    
    func shieldWork() {
        workStore.shield(familyActivitySelection: workSelection)
    }
    
    func removeEntertainmentShielding() {
        removeShielding(for: entertainmentStore)
    }
    
    func removeWorkShielding() {
        removeShielding(for: workStore)
    }
    
    func unlockEntertainmentActivities(for minutes: Int) {
        guard minutes >= 1 else {
            print("Unlock duration must be at least 1 minute")
            return
        }
        
        let now = Date()
        let calendar = Calendar.current
        
        let startDate = calendar.date(byAdding: .minute, value: -15, to: now)! // interval can be at least 15 minutes
        let endDate = calendar.date(byAdding: .minute, value: minutes, to: now)!
        
        // Note: including all components seems to resolve some issues related to DeviceActivityMonitorExtension
        let intervalStart = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startDate)
        let intervalEnd = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: endDate)
        
        let schedule = DeviceActivitySchedule(intervalStart: intervalStart, intervalEnd: intervalEnd, repeats: false, warningTime: DateComponents(second: 30)) // time bounds in which extension will monitor for activity
        
        let center = DeviceActivityCenter()
        do {
            try center.startMonitoring(.allow, during: schedule)
            removeEntertainmentShielding()
        } catch {
            print("Error occured while unlocking activities: \(error)")
        }
    }
    
    func trackWorkActivities(thresholdUsageMinutes threshold: Int, duringIntervalMinutes interval: Int) {
        guard interval > threshold && interval >= 15 else {
            print("Interval must be greater than threshold & it must be greater than 15 minutes")
            return
        }
        
        productivityUsageThreshold = threshold
        productivityInterval = interval
        saveProductivitySettings()
        
        print(productivityUsageThreshold, productivityInterval)
        
        let now = Date()
        let calendar = Calendar.current
        
        let productivityStartDate = now
        let productivityEndDate = calendar.date(byAdding: .minute, value: productivityInterval, to: now)!
        
        let intervalStart = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: productivityStartDate)
        let intervalEnd = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: productivityEndDate)
        
        let productivitySchedule = DeviceActivitySchedule(intervalStart: intervalStart, intervalEnd: intervalEnd, repeats: false, warningTime: DateComponents(minute: productivityUsageThreshold))
        
        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
            .productivityUsageThresholdEvent: DeviceActivityEvent(applications: workSelection.applicationTokens, threshold: DateComponents(minute: productivityUsageThreshold))
        ]
        
        let center = DeviceActivityCenter()
        do {
            try center.startMonitoring(.productivityFirst, during: productivitySchedule, events: events)
        } catch {
            print("Error occured while starting to monitor productivity: \(error)")
        }
        
    }
    
    func scheduleProductivityFirst() {
        let now = Date()
        let calendar = Calendar.current
        
        let productivityStartDate = now
        let productivityEndDate = calendar.date(byAdding: .minute, value: productivityInterval, to: now)!
        
        let intervalStart = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: productivityStartDate)
        let intervalEnd = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: productivityEndDate)
        
        let productivitySchedule = DeviceActivitySchedule(intervalStart: intervalStart, intervalEnd: intervalEnd, repeats: false, warningTime: DateComponents(minute: productivityUsageThreshold))
        
        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
            .productivityUsageThresholdEvent: DeviceActivityEvent(applications: workSelection.applicationTokens, threshold: DateComponents(minute: productivityUsageThreshold))
        ]
        
        let center = DeviceActivityCenter()
        do {
            try center.startMonitoring(.productivityFirst, during: productivitySchedule, events: events)
        } catch {
            print("Error occured while starting to monitor productivity: \(error)")
        }
    }
    
    func scheduleProductivitySecond() {
        let now = Date()
        let calendar = Calendar.current
        
        let productivityStartDate = now
        let productivityEndDate = calendar.date(byAdding: .minute, value: productivityInterval, to: now)!
        
        let intervalStart = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: productivityStartDate)
        let intervalEnd = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: productivityEndDate)
        
        let productivitySchedule = DeviceActivitySchedule(intervalStart: intervalStart, intervalEnd: intervalEnd, repeats: false, warningTime: DateComponents(minute: productivityUsageThreshold))
        
        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
            .productivityUsageThresholdEvent: DeviceActivityEvent(applications: workSelection.applicationTokens, threshold: DateComponents(minute: productivityUsageThreshold))
        ]
        
        let center = DeviceActivityCenter()
        do {
            try center.startMonitoring(.productivitySecond, during: productivitySchedule, events: events)
        } catch {
            print("Error occured while starting to monitor productivity: \(error)")
        }
    }
    
    func clearAllSettings() {
        entertainmentStore.clearAllSettings()
        workStore.clearAllSettings()
        defaultStore.clearAllSettings()
    }
    
}

extension ShieldViewModel {
    private func saveCodable<T: Codable>(_ value: T, forKey key: String, in defaults: UserDefaults) {
        if let data = try? JSONEncoder().encode(value) {
            defaults.set(data, forKey: key)
        }
    }
    
    private func loadCodable<T: Codable>(_ type: T.Type, forKey key: String, from defaults: UserDefaults) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
    
    private func loadSelections() {
        let defaults = UserDefaults(suiteName: "group.com.app.cognize") ?? .standard
        if let e = loadCodable(FamilyActivitySelection.self, forKey: "entertainmentSelection", from: defaults) {
            entertainmentSelection = e
        }
        if let w = loadCodable(FamilyActivitySelection.self, forKey: "workSelection", from: defaults) {
            workSelection = w
        }
        
        if let pThreshold = loadCodable(Int.self, forKey: "productivityUsageThreshold", from: defaults) {
            productivityUsageThreshold = pThreshold
        }
        if let pInterval = loadCodable(Int.self, forKey: "productivityInterval", from: defaults) {
            productivityInterval = pInterval
        }
    }
    
    func saveSelections() {
        let defaults = UserDefaults(suiteName: "group.com.app.cognize") ?? .standard
        saveCodable(entertainmentSelection, forKey: "entertainmentSelection", in: defaults)
        saveCodable(workSelection, forKey: "workSelection", in: defaults)
    }
    
    func saveProductivitySettings() {
        let defaults = UserDefaults(suiteName: "group.com.app.cognize") ?? .standard
        saveCodable(productivityUsageThreshold, forKey: "productivityUsageThreshold", in: defaults)
        saveCodable(productivityInterval, forKey: "productivityInterval", in: defaults)
    }
    
}


