//
//  CategoryStore.swift
//  Cognize
//
//  Created by Matvii Ustich on 25/07/2025.
//

import Foundation
import FamilyControls

final class CategoryStore {
    static let shared = CategoryStore()

    private let suiteName = "group.com.app.cognize"
    private let categoriesKey = "categories"
    
    private init() {}

    private var defaults: UserDefaults {
        UserDefaults(suiteName: suiteName) ?? .standard
    }

    func save(_ categories: [Category]) {
        do {
            let data = try JSONEncoder().encode(categories)
            defaults.set(data, forKey: categoriesKey)
        } catch {
            print("Failed to encode categories: \(error)")
        }
    }

    func load() -> [Category] {
        guard let data = defaults.data(forKey: categoriesKey) else { return [] }

        do {
            return try JSONDecoder().decode([Category].self, from: data)
        } catch {
            print("Failed to decode categories: \(error)")
            return []
        }
    }

    func clear() {
        defaults.removeObject(forKey: categoriesKey)
    }
}
