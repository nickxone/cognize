//
//  RestrictionConfiguration.swift
//  Cognize
//
//  Created by Matvii Ustich on 07/08/2025.
//

import FamilyControls

enum RestrictionConfiguration: Codable, Equatable {
    case shield(ShieldRestriction.Configuration)
    case interval(IntervalRestriction.Configuration)
    case open(OpenRestriction.Configuration)
    
    var appSelection: FamilyActivitySelection {
        switch self {
        case .shield(let config): return config.appSelection
        case .interval(let config): return config.appSelection
        case .open(let config): return config.appSelection
        }
    }
}
