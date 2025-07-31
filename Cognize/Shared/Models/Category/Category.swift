//
//  Category.swift
//  Cognize
//
//  Created by Matvii Ustich on 25/07/2025.
//

import Foundation
import FamilyControls
import SwiftUI

/// A model representing a user-defined app usage category, including the selected apps, restriction type, and associated color.
///
/// This class encapsulates:
/// - A unique `id` to identify the category.
/// - A `name` for user display.
/// - An `appSelection` to define which apps are part of the category (via `FamilyActivitySelection`).
/// - A `restrictionType` that determines how usage is limited (e.g., allow, shield, interval).
/// - A `color` for visual differentiation in the UI, stored in a codable format using `Data`.
///
/// It also includes:
/// - A computed `strategy` property which returns the corresponding `RestrictionStrategy` (e.g., shield or interval-based),
///   dynamically constructed based on the selected restriction type.
/// - Computed `color` property backed by encoded `Data` for storage compatibility.
///
/// This model enables the app to group apps under customizable categories and apply personalized usage control logic.
class Category: Codable, ObservableObject, Identifiable, Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum RestrictionType: String, Codable {
        case shield
        case interval
        case allow
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
