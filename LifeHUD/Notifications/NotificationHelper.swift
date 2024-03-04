//
//  NotificationHelper.swift
//  LifeHUD
//
//  Created by  Даниил Хомяков on 07.12.2022.
//

import Foundation
import UIKit
import UserNotifications

class NotificationHelper {
    static func createNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
           
        // Create the trigger as a repeating event.
        let targetDate = Date(timeIntervalSinceNow: 10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.second], from: targetDate), repeats: true)

        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)

        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
           var identifiers: [String] = []
           for notification:UNNotificationRequest in notificationRequests {
               if notification.identifier == uuidString {
                  identifiers.append(notification.identifier)
               }
           }
           UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
              if error != nil {
                debugPrint("center.add(request, withCompletionHandler: { (error)")
              } else {
                debugPrint("no error?! at request added place")
              }
            })
    }
}

final class NotificationOperation: Operation {

    override func main() {
        guard !isCancelled else { return }
        print("Importing content..")
        
        ChallengesManager.shared.fetchChallenges {_ in
            let number = ChallengesManager.shared.dailyChallenges.count
            NotificationHelper.createNotification(title: "Задания", body: "Невыполненных заданий: \(number)")
        }

    }
}

