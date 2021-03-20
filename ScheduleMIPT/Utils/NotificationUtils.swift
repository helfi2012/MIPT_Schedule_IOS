//
//  NotificationUtils.swift
//  ScheduleMIPT
//
//  Created by Яков Каюмов on 22.02.2021.
//  Copyright © 2021 Admin. All rights reserved.
//

import UIKit

class NotificationUtils {
    
    /**
        Cancels all existing pending notifications
     */
    static func cancelNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        print("Notifications have been canceled")
    }
    
    
    /**
        Creates and post repeating notifications for every lesson in `schedule.timetable[key]`.
     */
    static func scheduleNotifications(key: String, schedule: Schedule) {
        DispatchQueue(label: "queue_notifications_update").async {
            print("'scheduleNotifications' was called")
            // Check if notifications are enabled by the user
            let enabled = UserDefaults.standard.bool(forKey: SettingsView.NOTIFICATIONS_KEY)
            print("     enabled=" + String(enabled))
            guard enabled else { return }
            
            // get minutes before lesson from preferences
            let minutesBefore = SettingsView.getMinutesBefore(option: UserDefaults.standard.integer(forKey: SettingsView.NOTIFY_MINUTES_KEY))
            
            let center = UNUserNotificationCenter.current()
            
            center.getNotificationSettings { settings in
                
                print("     authorizationStatus = " + String(settings.authorizationStatus == .authorized))
                // Check authorization status
                guard (settings.authorizationStatus == .authorized) else { return }
                
                // Remove existing notifications
                center.removeAllPendingNotificationRequests()
                
                let items = schedule.timetable[key]!
                
                for item in items {
                    // Set up body of the notification
                    let content = UNMutableNotificationContent()
                    content.title = item.name
                    if item.place.isEmpty {
                        content.title = item.name
                        content.body = "\(NSLocalizedString("notification_text_at", comment: "At")) \(item.startTime)"
                    } else {
                        content.title = item.name
                        content.body = "\(NSLocalizedString("notification_text_at", comment: "At")) \(item.startTime) \(NSLocalizedString("notification_text_in", comment: "in")) \(item.place)"
                    }
                    
                    content.categoryIdentifier = "alarm"
                    content.sound = UNNotificationSound.default
                    
                    // Configure time of the notification
                    let split = item.startTime.split(separator: ":")
                    var hour = Int(split[0])!
                    var minute = Int(split[1])!
                    minute -= minutesBefore
                    if minute < 0 {
                        hour -= 1
                        minute += 60
                    }
                    
                    var dateComponents = DateComponents()
                    dateComponents.weekday = TimeUtils.myDayToIOSDay(weekday: item.day)
                    dateComponents.hour = hour
                    dateComponents.minute = minute

                    // Creating trigger
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    
                    // Add notification to the notification center
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    center.add(request)
                }
            }
        }
    }
}
