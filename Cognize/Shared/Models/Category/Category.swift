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
    var appSelection: FamilyActivitySelection
    var configurations: [RestrictionConfiguration]
    private var colorData: Data?
    
    init(name: String, appSelection: FamilyActivitySelection, color: Color, configuration: RestrictionConfiguration) {
        self.id = UUID()
        self.name = name
        self.configurations = [configuration]
        self.colorData = try? encodeColor(color)
        self.appSelection = appSelection
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
    
    var configuration: RestrictionConfiguration {
        get {
            guard let config = currentConfiguration() else {
                fatalError("No configuration found for \(self.name)")
            }
            return config
        }
        set {
            // Find the index of the current configuration
            if let idx = configurations.firstIndex(where: { $0 == currentConfiguration() }) {
                configurations[idx] = newValue
            } else {
                configurations.append(newValue)
            }
        }
    }
    
}

extension Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Category {
    private func currentConfiguration() -> RestrictionConfiguration? {
        guard !configurations.isEmpty else { return nil }
        
        let cal = Calendar.current
        let now = cal.dateComponents([.hour, .minute], from: Date())
        let nowM = (now.hour ?? 0) * 60 + (now.minute ?? 0)
        
        func minutes(_ comps: DateComponents) -> Int {
            (comps.hour ?? 0) * 60 + (comps.minute ?? 0)
        }
        
        return configurations.first { config in
            let startM = minutes(config.common.startTime)
            let endM   = minutes(config.common.endTime)
            
            if startM <= endM { // Same-day window
                return startM <= nowM && nowM <= endM
            } else { // Overnight window: e.g. 22:00–02:00
                return nowM >= startM || nowM <= endM
            }
        }
    }
    
    func makeStrategy() -> RestrictionStrategy {
        let currConfig = currentConfiguration()
        guard let configuration = currConfig else {
            fatalError("No configuration found for \(self)")
        }
        switch configuration {
        case .shield:
            let strategy = ShieldRestriction(categoryId: id, appSelection: appSelection, configuration: configuration)
            return strategy
        case .interval:
            let strategy = IntervalRestriction(categoryId: id, appSelection: appSelection, configuration: configuration)
            return strategy
        case .open:
            let strategy = OpenRestriction(categoryId: id, appSelection: appSelection, configuration: configuration)
            return strategy
        }
    }
}
