//
//  RestrictionConfiguration.swift
//  Cognize
//
//  Created by Matvii Ustich on 07/08/2025.
//

import FamilyControls

enum RestrictionConfiguration: Codable, Equatable {
    case shield(ShieldConfig)
    case interval(IntervalConfig)
    case allow(AllowConfig)
    
    struct ShieldConfig: Codable, Equatable {
        var appSelection: FamilyActivitySelection
        var timeAllowed: Int
        var opensAllowed: Int
    }
    
    struct IntervalConfig: Codable, Equatable {
        var appSelection: FamilyActivitySelection
        var thresholdTime: Int
        var intervalLength: Int
    }
    
    struct AllowConfig: Codable, Equatable {
        var appSelection: FamilyActivitySelection
        var hasLimit: Bool
        var timeLimit: Int
    }
    
    var appSelection: FamilyActivitySelection {
        switch self {
        case .shield(let config): return config.appSelection
        case .interval(let config): return config.appSelection
        case .allow(let config): return config.appSelection
        }
    }
}
