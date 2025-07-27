//
//  Category.swift
//  Cognize
//
//  Created by Matvii Ustich on 25/07/2025.
//

import Foundation
import FamilyControls

class Category: Codable, ObservableObject {
    enum RestrictionType: String, Codable {
        case allow
        case shield
        case interval
    }
    
    var id: UUID
    var name = String()
    var appSelection: FamilyActivitySelection
    var restrictionType: RestrictionType
    
    init(name: String, appSelection: FamilyActivitySelection, restrictionType: RestrictionType) {
        self.id = UUID()
        self.name = name
        self.appSelection = appSelection
        self.restrictionType = restrictionType
    }
    
    var strategy: RestrictionStrategy {
        switch restrictionType {
        case .shield:
            return ShieldRestriction(categoryName: name, categoryId: id, appSelection: appSelection)
        case .allow:
            return ShieldRestriction(categoryName: name, categoryId: id, appSelection: appSelection)
        case .interval:
            return IntervalTrackRestriction(categoryName: name, categoryId: id, appSelection: appSelection)
        }
    }
    
}
