//
//  NotificationService.swift
//  RSSManager
//
//  Created by Marko Matijević on 13.12.2023..
//

import Foundation
import UserNotifications

protocol NotificationServiceProtocol {
    func getNotificationsPermission()
    func showLocalNotification()
}

class NotificationService: NotificationServiceProtocol {
    func getNotificationsPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    func showLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "RSSManager"
        content.body = "There have been updates on your favourite RSS channels."
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "updateNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
