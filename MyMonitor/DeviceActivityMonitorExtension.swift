//
//  DeviceActivityMonitorExtension.swift
//  MyMonitor
//
//  Created by Matvii Ustich on 18/07/2025.
//

// Neither logs nor print statements seem to work from this extension
import DeviceActivity
import ManagedSettings
import UserNotifications

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    // let store = ManagedSettingsStore() // get access to application shield restriction
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        // Handle the start of the interval.
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        // Handle the end of the interval.
        if activity == .allow {
            NotificationManager.shared.scheduleNotification(title: "End schedule", body: "Ended \(activity.rawValue)", inSeconds: 1.5)
            let model = ShieldViewModel()
            model.shieldEntertainment()
        }
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold.
        if event == .productivityUsageThresholdEvent {
            let model = ShieldViewModel()
            model.shieldWork()
            NotificationManager.shared.scheduleNotification(title: "Log your intention", body: "\(activity.rawValue)", inSeconds: 1.5)
        }
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
        if activity == .allow {
            NotificationManager.shared.scheduleNotification(title: "Cognize", body: "Apps are about to relock", inSeconds: 1.5)
        } else if activity == .productivityFirst {
            let model = ShieldViewModel()
            model.scheduleProductivityFirst()
        } else if activity == .productivitySecond {
            let model = ShieldViewModel()
            model.scheduleProductivityFirst()
        }
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
        if event == .productivityUsageThresholdEvent {
            NotificationManager.shared.scheduleNotification(title: "Productivity", body: "Remember to log your intention beforehand", inSeconds: 1.5)
        }
    }
}
