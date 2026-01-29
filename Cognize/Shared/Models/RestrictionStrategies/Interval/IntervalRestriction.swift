//
//  IntervalTrackRestriction.swift
//  Cognize
//
//  Created by Matvii Ustich on 25/07/2025.
//

import Foundation
import ManagedSettings
import FamilyControls
import DeviceActivity

struct IntervalConfig: Codable, Equatable {
    var thresholdTime: Int
    var intervalLength: Int
//    var limit: Limit
//    
//    enum Limit: Codable, Equatable {
//        case timeLimit(minutesAllowed: Int)
//        case none
//    }
}

class IntervalRestriction: BaseRestriction {
    var config: IntervalConfig
    
    init(categoryId: UUID, appSelection: FamilyActivitySelection, configuration: RestrictionConfiguration) {
        guard case let .interval(intervalConfig) = configuration else {
            preconditionFailure("IntervalRestriction requires .interval configuration")
        }
        self.config = intervalConfig
        super.init(categoryId: categoryId, appSelection: appSelection)
    }
    
    private var deviceActivityNameFirst: DeviceActivityName {
        .init("first-\(categoryId.uuidString)")
    }
    
    private var deviceActivityNameSecond: DeviceActivityName {
        .init("second-\(categoryId.uuidString)")
    }
    
    private var deviceActivityEventName: DeviceActivityEvent.Name {
        .init("event-\(categoryId.uuidString)")
    }
    
    func scheduleProductivity(name: DeviceActivityName) {
        let schedule = createSchedule(
            endOffset: TimeInterval(config.intervalLength * 60),
            warningTime: DateComponents(minute: config.thresholdTime)
        )
        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
            deviceActivityEventName: DeviceActivityEvent(
                applications: appSelection.applicationTokens, // potential source of errors in case appSelection contains categoryTokens rather than applicationTokens
                categories: appSelection.categoryTokens,
                webDomains: appSelection.webDomainTokens,
                threshold: DateComponents(minute: config.thresholdTime)
            )
        ]
        
        do {
            try DeviceActivityCenter().startMonitoring(name, during: schedule, events: events)
            print("Start monitoring: \(name) \(schedule) \(events)")
        } catch {
            print("Failed to schedule productivity event (\(name.rawValue)): \(error)")
        }
    }
    
    func track() {
        guard config.intervalLength > config.thresholdTime && config.intervalLength >= 15  && config.thresholdTime >= 1 else {
            print("Interval must be greater than threshold & interval must be greater than 15 minutes & threshold must be greater than 1 minute")
            return
        }
        
        scheduleProductivity(name: deviceActivityNameFirst)
        NotificationManager.shared.scheduleNotification(title: "track", body: "\(config.thresholdTime) \(config.intervalLength)", inSeconds: 1.5)
    }
    
}

extension IntervalRestriction: RestrictionStrategy {
    func start() {
        track()
    }
    
    func finish() {
        removeShielding()
        DeviceActivityCenter().stopMonitoring([deviceActivityNameFirst, deviceActivityNameSecond])
    }
    
    func intervalDidStart(for activity: DeviceActivityName) {
        NotificationManager.shared.scheduleNotification(title: "intervalDidStart", body: "\(activity.rawValue)", inSeconds: 1.5)
    }
    
    func intervalDidEnd(for activity: DeviceActivityName) {
        NotificationManager.shared.scheduleNotification(title: "intervalDidEnd", body: "\(activity.rawValue)", inSeconds: 1.5)
    }
    
    func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, for activity: DeviceActivityName) {
        if event == deviceActivityEventName {
            shield()
            NotificationManager.shared.scheduleNotification(title: "Log your intention", body: "\(event.rawValue) \(activity.rawValue)", inSeconds: 1.5)
        }
    }
    
    func intervalWillStartWarning(for activity: DeviceActivityName) {
        NotificationManager.shared.scheduleNotification(title: "intervalWillStartWarning", body: "\(activity.rawValue)", inSeconds: 1.5)
    }
    
    func intervalWillEndWarning(for activity: DeviceActivityName) {
        if activity == deviceActivityNameFirst {
            // schedule second
            scheduleProductivity(name: deviceActivityNameSecond)
        } else if activity == deviceActivityNameSecond {
            // schedule first otherwise
            scheduleProductivity(name: deviceActivityNameFirst)
        }
    }
    
    func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, for activity: DeviceActivityName) {
        NotificationManager.shared.scheduleNotification(title: "eventWillReachThresholdWarning", body: "\(event.rawValue) \(activity.rawValue)", inSeconds: 1.5)
    }
    
}
