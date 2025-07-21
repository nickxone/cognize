//
//  ShieldViewModel+Storage.swift
//  Cognize
//
//  Created by Matvii Ustich on 21/07/2025.
//

import Foundation
import FamilyControls

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
    
    func loadSelections() {
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


