//
//  CategoryStore+Environment.swift
//  Cognize
//
//  Created by Matvii Ustich on 27/07/2025.
//

import Foundation
import SwiftUI

private struct CategoryStoreKey: EnvironmentKey {
    static let defaultValue = CategoryStore.shared
}

extension EnvironmentValues {
    var categoryStore: CategoryStore {
        get { self[CategoryStoreKey.self] }
        set { self[CategoryStoreKey.self] = newValue }
    }
}
