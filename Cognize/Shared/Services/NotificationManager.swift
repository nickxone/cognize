//
//  NotificationManager.swift
//  Cognize
//
//  Created by Matvii Ustich on 19/07/2025.
//

//import Foundation
//import UserNotifications
//
//final class NotificationManager {
//
//    static let shared = NotificationManager()
//    private let center = UNUserNotificationCenter.current()
//
//    private init() {}
//
//    // Request permission (call once)
//    func requestAuthorization(completion: @escaping (Bool) -> Void = { _ in }) {
//        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
//            completion(granted)
//        }
//    }
//
//    // Schedule a local notification
//    func scheduleNotification(
//        title: String,
//        body: String,
//        inSeconds seconds: TimeInterval,
//        identifier: String = UUID().uuidString
//    ) {
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//        center.add(request) { error in
//            if let error = error {
//                print("Failed to schedule notification: \(error)")
//            }
//        }
//    }
//
//    // Cancel notification by ID
//    func cancelNotification(identifier: String) {
//        center.removePendingNotificationRequests(withIdentifiers: [identifier])
//    }
//
//    // Cancel all
//    func cancelAllNotifications() {
//        center.removeAllPendingNotificationRequests()
//    }
//}

import Foundation
import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationManager()
    private let center = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()
        center.delegate = self
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void = { _ in }) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            completion(granted)
        }
    }
    
    func scheduleNotification(
        title: String,
        body: String,
        inSeconds seconds: TimeInterval,
        identifier: String = UUID().uuidString
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }
    
    func cancelNotification(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
    }
    
    // Show notifications even when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .list])
    }
}
