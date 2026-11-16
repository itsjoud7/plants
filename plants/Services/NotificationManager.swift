//
//  NotificationManager.swift
//  plants
//
//  Created by jood on 30/05/1448 AH.
//

import Foundation
import UserNotifications

struct NotificationManager {

    static let testMode = true
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    static func schedule(for reminder: PlantReminder) {
        let content = UNMutableNotificationContent()
        content.title = "Planto"
        content.body = "Hey! let's water your \(reminder.name) 🌱"
        content.sound = .default

        let seconds: TimeInterval
        if testMode {
            seconds = 10
        } else {
            seconds = TimeInterval(reminder.watering.days * 24 * 60 * 60)
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: !testMode)

        let request = UNNotificationRequest(
            identifier: reminder.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    static func cancel(for reminder: PlantReminder) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [reminder.id.uuidString]
        )
    }
}
