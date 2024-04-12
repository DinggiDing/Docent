//
//  NotificationManager.swift
//  Docent_swift
//
//  Created by 성재 on 2022/10/30.
//

import Foundation
import SwiftUI
import UserNotifications

class NotificationManager {
    static let instance = NotificationManager()
    private init() {}
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("SUCCESS")
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Docent"
        content.body = "새로운 상품을 소개해드릴께요"
        content.sound = .default
        content.badge = 1
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()   // 초기화

        let datecomponent = DateComponents(hour: 10, minute: 00)
        let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponent, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
}
