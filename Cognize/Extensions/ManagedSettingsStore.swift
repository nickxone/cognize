//
//  ManagedSettingsStore.swift
//  Cognize
//
//  Created by Matvii Ustich on 17/07/2025.
//

import Foundation
import ManagedSettings
import FamilyControls

extension ManagedSettingsStore {
    
    func shield(familyActivitySelection: FamilyActivitySelection) {
        clearAllSettings()
        
        let applicationTokens = familyActivitySelection.applicationTokens
        let categoryTokens = familyActivitySelection.categoryTokens
        
        shield.applications = applicationTokens.isEmpty ? nil : applicationTokens
        shield.applicationCategories = categoryTokens.isEmpty ? nil : .specific(categoryTokens)
        shield.webDomainCategories = categoryTokens.isEmpty ? nil : .specific(categoryTokens)
    }
}

extension ManagedSettingsStore.Name {
    static let entertainment = Self("entertainment")
}
