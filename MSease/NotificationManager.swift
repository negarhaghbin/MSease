//
//  NotificationManager.swift
//  MSease
//
//  Created by Negar on 2021-04-21.
//

import UserNotifications

enum notificationCategory : String{
    case snoozable = "SNOOZABLE"
}

enum notificationAction : String{
    case snooze = "SNOOZE_ACTION"
}


func scheduleNotification(reminder: Reminder){
    let time = getTimeFromString(reminder.time)
    let content = UNMutableNotificationContent()
    content.title = reminder.name
    content.body = reminder.message
    content.sound = UNNotificationSound.default
    content.categoryIdentifier = notificationCategory.snoozable.rawValue
    content.userInfo = ["id": reminder._id.stringValue]

    // weekday = 1, sunday
    // weekday = 0, saturday
    
    var triggerRepeat = Calendar.current.dateComponents([.weekday,.hour, .minute], from: Date())
    triggerRepeat.hour = time.h
    triggerRepeat.minute = time.m
    
    if reminder.mon{
        triggerRepeat.weekday = 2
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerRepeat, repeats: true)

        let request = UNNotificationRequest(identifier: reminder._id.stringValue+"2", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    if reminder.tue{
        triggerRepeat.weekday = 3
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerRepeat, repeats: true)

        let request = UNNotificationRequest(identifier: reminder._id.stringValue+"3", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    if reminder.wed{
        triggerRepeat.weekday = 4
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerRepeat, repeats: true)

        let request = UNNotificationRequest(identifier: reminder._id.stringValue+"4", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    if reminder.thu{
        triggerRepeat.weekday = 5
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerRepeat, repeats: true)

        let request = UNNotificationRequest(identifier: reminder._id.stringValue+"5", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    if reminder.fri{
        triggerRepeat.weekday = 6
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerRepeat, repeats: true)

        let request = UNNotificationRequest(identifier: reminder._id.stringValue+"6", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    if reminder.sat{
        triggerRepeat.weekday = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerRepeat, repeats: true)

        let request = UNNotificationRequest(identifier: reminder._id.stringValue+"0", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    if reminder.sun{
        triggerRepeat.weekday = 1
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerRepeat, repeats: true)

        let request = UNNotificationRequest(identifier: reminder._id.stringValue+"1", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
}

extension UNNotification {
    func snoozeNotification(notificationContent: UNNotificationContent) {
        let content = UNMutableNotificationContent()
        content.title = notificationContent.title
        content.body = notificationContent.body
        content.sound = .default
        content.categoryIdentifier = notificationCategory.snoozable.rawValue

        let identifier = self.request.identifier
//        UUID().uuidString
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .hour, value: 1, to: Date())
                
        let dateComponent = calendar.dateComponents([.hour,.minute], from: date!)
                
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                debugPrint("Rescheduling failed", error.localizedDescription)
            } else {
                debugPrint("rescheduled success")
            }
        }
    }

}
