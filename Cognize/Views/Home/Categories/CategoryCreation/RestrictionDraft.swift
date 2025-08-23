//
//  RestrictionDraft.swift
//  Cognize
//
//  Created by Matvii Ustich on 09/08/2025.
//

import Foundation
import FamilyControls

/// Ephemeral editor state that mirrors the UI controls.
/// This is editted  and only converted to `RestrictionConfiguration` on Done.
struct RestrictionDraft {
    enum Kind { case shield, interval, open }
    
    var kind: Kind = .shield
    var common: RestrictionCommon = RestrictionCommon(appSelection: FamilyActivitySelection(), startTime: DateComponents(hour: 0, minute: 0), endTime: DateComponents(hour: 23, minute: 59))
    var shield: Shield = Shield()
    var interval: Interval = Interval()
    var open: Open = Open()
    
    // shield
    struct Shield {
        enum Kind { case shieldTime, shieldOpen}
        var kind: Kind = .shieldTime
        var shieldMinutesAllowed: Int = 30
        var shieldOpensAllowed: Int = 5
        var shieldMinutesPerOpen: Int = 5
    }
    
    // interval
    struct Interval {
        enum Kind { case timeLimit, none }
        var kind: Kind = .none
        var timeLimit: Int = 60
        var intervalThresholdTime: Int = 5
        var intervalLength: Int = 30
    }
    
    // open
    struct Open {
        enum Kind { case openAlways, openLimit}
        var kind: Kind = .openAlways
        var openMinutesAllowed: Int = 30
    }
}

extension RestrictionDraft {
    func asConfiguration() -> RestrictionConfiguration {
        switch kind {
        case .shield:
            switch shield.kind {
            case .shieldOpen:
                return .shield(common: common, .init(limit: .openLimit(opensAllowed: shield.shieldOpensAllowed, minutesPerOpen: shield.shieldMinutesPerOpen)))
            case .shieldTime:
                return .shield(common: common, .init(limit: .timeLimit(minutesAllowed: shield.shieldMinutesAllowed)))
            }
        case .interval:
            return .interval(common: common, .init(thresholdTime: interval.intervalThresholdTime, intervalLength: interval.intervalLength))
        case .open:
            switch open.kind {
            case .openAlways:
                return .open(common: common, .init(limit: .alwaysOpen))
            case .openLimit:
                return .open(common: common, .init(limit: .timeLimit(minutes: open.openMinutesAllowed)))
            }
        }
    }
    //    init(from config: RestrictionConfiguration) {
    //        switch config {
    //        case .shield(let c):
    //            appSelection = c.appSelection
    //            switch c.limit {
    //            case .timeLimit(let mins):
    //                kind = .shieldTime
    //                shieldMinutesAllowed = mins
    //            case .openLimit(let opens, let minutesPerOpen):
    //                kind = .shieldOpen
    //                shieldOpensAllowed = opens
    //                shieldMinutesPerOpen = minutesPerOpen
    //            }
    //
    //        case .interval(let c):
    //            kind = .interval
    //            appSelection = c.appSelection
    //            intervalThresholdTime = c.thresholdTime
    //            intervalLength = c.intervalLength
    //
    //        case .open(let c):
    //            appSelection = c.appSelection
    //            switch c.limit {
    //            case .timeLimit(let mins):
    //                kind = .openTime
    //                openMinutesAllowed = mins
    //            case .alwaysOpen:
    //                kind = .openAlways
    //            }
    //        }
    //    }
    
    //    func asConfiguration() -> RestrictionConfiguration {
    //        switch kind {
    //        case .shieldTime:
    //            return .shield(.init(appSelection: appSelection, limit: .timeLimit(minutesAllowed: shieldMinutesAllowed)))
    //        case .shieldOpen:
    //            return .shield(.init(appSelection: appSelection, limit: .openLimit(opensAllowed: shieldOpensAllowed, minutesPerOpen: shieldMinutesPerOpen)))
    //        case .interval:
    //            return .interval(.init(appSelection: appSelection, thresholdTime: intervalThresholdTime, intervalLength: intervalLength))
    //        case .openTime:
    //            return .open(.init(appSelection: appSelection, limit: .timeLimit(minutes: openMinutesAllowed)))
    //        case .openAlways:
    //            return .open(.init(appSelection: appSelection, limit: .alwaysOpen))
    //        }
    //    }
}
