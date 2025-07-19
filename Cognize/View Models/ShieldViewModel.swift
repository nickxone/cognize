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
    
    private let store = ManagedSettingsStore()
    
    init() {
        loadSelection()
    }
    
    func shieldActivities() {
        store.shield(familyActivitySelection: selectionToDiscourage)
    }
    
    func unlockActivities(for minutes: Int) {
        let now = Date()
        let endDate = Calendar.current.date(byAdding: .minute, value: 15, to: now)!

        let intervalStart = Calendar.current.dateComponents([.hour, .minute, .second], from: now)
        let intervalEnd = Calendar.current.dateComponents([.hour, .minute, .second], from: endDate)
        
        let schedule = DeviceActivitySchedule(intervalStart: intervalStart, intervalEnd: intervalEnd, repeats: false, warningTime: DateComponents(minute: 14)) // time bounds in which extension will monitor for activity
        
        let center = DeviceActivityCenter()
        do {
            try center.startMonitoring(.daily, during: schedule)
        } catch {
            print("Error occured while unlocking activities: \(error)")
        }
    }
    
    func removeShielding() {
        store.shield.applications = nil // just adding applications won't always work
        store.shield.applicationCategories = nil
        store.shield.webDomainCategories = nil
        store.shield.webDomains = nil
    }
    
    func clearAllSettings() {
        store.clearAllSettings()
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


