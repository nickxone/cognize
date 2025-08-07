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
    private func findCategory(for activity: DeviceActivityName) -> Category? {
        let categories = CategoryStore.shared.load()
        return categories.first { activity.rawValue.contains($0.id.uuidString) }
    }
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        // Handle the start of the interval.
        guard let category = findCategory(for: activity) else { return }
        let strategy = category.makeStrategy()
        strategy.intervalDidStart(for: activity)
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        // Handle the end of the interval.
        guard let category = findCategory(for: activity) else { return }
        let strategy = category.makeStrategy()
        strategy.intervalDidEnd(for: activity)
        //        if activity == .allow {
        //            NotificationManager.shared.scheduleNotification(title: "End schedule", body: "Ended \(activity.rawValue)", inSeconds: 1.5)
        //            let model = ShieldViewModel()
        //            model.shield(.entertainment)
        //        }
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold.
        guard let category = findCategory(for: activity) else { return }
        let strategy = category.makeStrategy()
        strategy.eventDidReachThreshold(event, for: activity)
        //        if event == .productivityUsageThresholdEvent {
        //            let model = ShieldViewModel()
        //            model.shield(.work)
        //            NotificationManager.shared.scheduleNotification(title: "Log your intention", body: "\(activity.rawValue)", inSeconds: 1.5)
        //        }
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
        guard let category = findCategory(for: activity) else { return }
        let strategy = category.makeStrategy()
        strategy.intervalWillStartWarning(for: activity)
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
        guard let category = findCategory(for: activity) else { return }
        let strategy = category.makeStrategy()
        strategy.intervalWillEndWarning(for: activity)
        //        if activity == .allow {
        //            NotificationManager.shared.scheduleNotification(title: "Cognize", body: "Apps are about to relock", inSeconds: 1.5)
        //        } else if activity == .productivityFirst {
        //            let model = ShieldViewModel()
        //            model.scheduleProductivity(name: .productivitySecond)
        //        } else if activity == .productivitySecond {
        //            let model = ShieldViewModel()
        //            model.scheduleProductivity(name: .productivityFirst)
        //        }
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
        guard let category = findCategory(for: activity) else { return }
        let strategy = category.makeStrategy()
        strategy.eventWillReachThresholdWarning(event, for: activity)
        //        if event == .productivityUsageThresholdEvent {
        //
        //        }
    }
}
