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
    
    var triggerRepeat = Calendar.current.dateComponents([.weekday,.hour, .minute], from: Date())
    triggerRepeat.hour = time.h
    triggerRepeat.minute = time.m
    
    // weekday = 1, sunday
    // weekday = 0, saturday
    
    let days = [(reminder.mon, triggerWeekday: 2),
                (reminder.tue, triggerWeekday: 3),
                (reminder.wed, triggerWeekday: 4),
                (reminder.thu, triggerWeekday: 5),
                (reminder.fri, triggerWeekday: 6),
                (reminder.sat, triggerWeekday: 0),
                (reminder.sun, triggerWeekday: 1)]
    
    for day in days{
        if day.0{
            triggerRepeat.weekday = day.triggerWeekday
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerRepeat, repeats: true)

            let request = UNNotificationRequest(identifier: reminder._id.stringValue+"\(day.triggerWeekday)", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request)
        }
    }
}

extension UNNotification {
    func snoozeNotification(notificationContent: UNNotificationContent) {
        let content = UNMutableNotificationContent()
        content.title = notificationContent.title
        content.body = notificationContent.body
        content.sound = .default
        content.categoryIdentifier = notificationCategory.snoozable.rawValue

        let identifier = request.identifier
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
