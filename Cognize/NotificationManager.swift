//
//  NotificationManager.swift
//  Cognize
//
//  Created by Matvii Ustich on 19/07/2025.
//

import Foundation
import UserNotifications

final class NotificationManager {
    
    static let shared = NotificationManager()
    private let center = UNUserNotificationCenter.current()
    
    private init() {}
    
    // Request permission (call this once, e.g. on first launch)
    func requestAuthorization(completion: @escaping (Bool) -> Void = { _ in }) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            completion(granted)
        }
    }
    
    // Schedule a local notification
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
    
    // Cancel notification by ID
    func cancelNotification(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    // Cancel all
    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
    }
}
