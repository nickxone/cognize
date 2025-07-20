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
    @Published var selectionToDiscourage = FamilyActivitySelection()
    
    private let entertainmentStore = ManagedSettingsStore(named: .entertainment)
    private let workStore = ManagedSettingsStore(named: .work)
    private let defaultStore = ManagedSettingsStore()
    
    init() {
        loadSelection()
    }
    
    private func shieldActivities(for store: ManagedSettingsStore) {
        store.shield(familyActivitySelection: selectionToDiscourage)
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
        
        print("intervalStart:", intervalStart)
        print("intervalEnd:", intervalEnd)
        
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
    func saveSelectionToDiscourage() {
        do {
            let data = try JSONEncoder().encode(selectionToDiscourage)
            let defaults = UserDefaults(suiteName: "group.com.app.cognize") ?? .standard
            defaults.set(data, forKey: "selectionToDiscourage")
        } catch {
            print("Failed to save selectionToDiscourage: \(error)")
        }
    }
    
    private func loadSelection() {
        let defaults = UserDefaults(suiteName: "group.com.app.cognize") ?? .standard
        if let data = defaults.data(forKey: "selectionToDiscourage") {
            do {
                let decoded = try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
                selectionToDiscourage = decoded
            } catch {
                print("Failed to load selectionToDiscourage: \(error)")
            }
        }
    }
}


