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
    
    private let entertainmentStore = ManagedSettingsStore(named: .entertainment)
    private let workStore = ManagedSettingsStore(named: .work)
    private let defaultStore = ManagedSettingsStore()
    
    init() {
        loadSelections()
    }
    
    private func shieldActivities(for store: ManagedSettingsStore) {
        store.shield(familyActivitySelection: entertainmentSelection)
    }
    
    private func removeShielding(for store: ManagedSettingsStore) {
        store.clearAllSettings()
    }
    
    func shieldEntertainment() {
        shieldActivities(for: entertainmentStore)
    }
    
    func unlockActivities(for minutes: Int) {
        guard minutes >= 1 else {
            print("Unlock duration must be at least 1 minute")
            return
        }
        
        let now = Date()
        let calendar = Calendar.current
        
        let startDate = calendar.date(byAdding: .minute, value: -15, to: now)! // interval can be at least 15 minutes
        let endDate = calendar.date(byAdding: .minute, value: minutes, to: now)!
        
        // Convert from 'startDate' and 'endDate' using calendar
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
    
    func removeEntertainmentShielding() {
        removeShielding(for: entertainmentStore)
    }
    
    func clearAllSettings() {
        entertainmentStore.clearAllSettings()
        workStore.clearAllSettings()
        defaultStore.clearAllSettings()
    }
    
}

extension ShieldViewModel {
    private func saveSelection(_ selection: FamilyActivitySelection, forKey key: String, in defaults: UserDefaults) {
        if let data = try? JSONEncoder().encode(selection) {
            defaults.set(data, forKey: key)
        }
    }
    
    private func loadSelection(forKey key: String, from defaults: UserDefaults) -> FamilyActivitySelection? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
    }
    
    private func loadSelections() {
        let defaults = UserDefaults(suiteName: "group.com.app.cognize") ?? .standard
        if let e = loadSelection(forKey: "entertainmentSelection", from: defaults) {
            entertainmentSelection = e
        }
        if let w = loadSelection(forKey: "workSelection", from: defaults) {
            workSelection = w
        }
    }
    
    func saveSelections() {
        let defaults = UserDefaults(suiteName: "group.com.app.cognize") ?? .standard
        saveSelection(entertainmentSelection, forKey: "entertainmentSelection", in: defaults)
        saveSelection(workSelection, forKey: "workSelection", in: defaults)
    }
    
}


