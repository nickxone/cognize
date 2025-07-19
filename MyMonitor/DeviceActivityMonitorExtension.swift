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
        let model = ShieldViewModel()
        model.removeShielding()
        NotificationManager.shared.scheduleNotification(title: "Start schedule", body: "Started", inSeconds: 2)
//        store.clearAllSettings() // setting store.shiels.applications to nil doesn't work
//        store.clearAllSettings()
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        // Handle the end of the interval.
        NotificationManager.shared.scheduleNotification(title: "End schedule", body: "Ended", inSeconds: 2)
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold.
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
        let model = ShieldViewModel()
        model.shieldActivities()
        NotificationManager.shared.scheduleNotification(title: "Schedule Warning", body: "Warning", inSeconds: 2)
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
}


extension ManagedSettingsStore.Name {
    static let gaming = Self("Gaming")
    static let social = Self("Social")
}
