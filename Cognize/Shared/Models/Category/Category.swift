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

class Category: Codable, Identifiable {

    var id: UUID
    var name = String()
    var configuration: RestrictionConfiguration
    private var colorData: Data?
    
    init(name: String, color: Color, configuration: RestrictionConfiguration) {
        self.id = UUID()
        self.name = name
        self.configuration = configuration
        self.colorData = try? encodeColor(color)
        makeStrategy().start()
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

extension Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Category {
    func makeStrategy() -> RestrictionStrategy {
        switch configuration {
        case .shield(let config):
            let strategy = ShieldRestriction(categoryId: id, config: config)
            return strategy
        case .interval(let config):
            let strategy = IntervalRestriction(categoryId: id, config: config)
            return strategy
        case .open(let config):
            let strategy = OpenRestriction(categoryId: id, config: config)
            return strategy
        }
    }
}
