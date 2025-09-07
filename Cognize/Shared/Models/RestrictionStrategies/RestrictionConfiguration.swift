//
//  RestrictionConfiguration.swift
//  Cognize
//
//  Created by Matvii Ustich on 07/08/2025.
//

import Foundation
import FamilyControls

/// Properties that are common to every `RestrictionConfiguration`
struct RestrictionCommon: Codable, Equatable {
    var startTime: DateComponents
    var endTime: DateComponents
}

/// Represents possible restrictions that the app supports
enum RestrictionConfiguration: Codable, Equatable {
    case shield(common: RestrictionCommon, ShieldConfig)
    case interval(common: RestrictionCommon, IntervalConfig)
    case open(common: RestrictionCommon, OpenConfig)
    
    var common: RestrictionCommon {
        get {
            switch self {
            case .shield(let c, _), .interval(common: let c, _), .open(common: let c, _): return c
            }
        }
        set {
            switch self {
            case .shield(_, let s): self = .shield(common: newValue, s)
            case .interval(_, let s): self = .interval(common: newValue, s)
            case .open(_, let s): self = .open(common: newValue, s)
            }
        }
    }
    
}
