//
//  RestrictionConfiguration.swift
//  Cognize
//
//  Created by Matvii Ustich on 07/08/2025.
//

import Foundation
import FamilyControls

/// Represents possible restrictions that the app supports
enum RestrictionConfiguration: Codable, Equatable {
    case shield(ShieldConfig)
    case interval(IntervalConfig)
    case open(OpenConfig)
    
}
