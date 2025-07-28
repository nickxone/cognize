//
//  Category.swift
//  Cognize
//
//  Created by Matvii Ustich on 25/07/2025.
//

import Foundation
import FamilyControls
import SwiftUI

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
    private var colorData: Data?
    
    init(name: String, appSelection: FamilyActivitySelection, restrictionType: RestrictionType, color: Color) {
        self.id = UUID()
        self.name = name
        self.appSelection = appSelection
        self.restrictionType = restrictionType
        self.colorData = try? encodeColor(color)
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
    
    var color: Color {
        get {
            if let data = colorData {
                do {
                    return try decodeColor(from: data)
                } catch {
                    print("Failed to decode color: \(error)")
                    return .blue
                }
            } else {
                return .blue
            }
        }
        set {
            colorData = try? encodeColor(newValue)
        }
    }
    
}
