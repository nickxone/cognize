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
    case open(OpenConfig)
    
    var appSelection: FamilyActivitySelection {
        get {
            switch self {
            case .shield(let c):   return c.appSelection
            case .interval(let c): return c.appSelection
            case .open(let c):    return c.appSelection
            }
        }
        set {
            switch self {
            case .shield(var c):   c.appSelection = newValue; self = .shield(c)
            case .interval(var c): c.appSelection = newValue; self = .interval(c)
            case .open(var c):    c.appSelection = newValue; self = .open(c)
            }
        }
    }
}
