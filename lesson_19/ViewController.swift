//
//  ViewController.swift
//  lesson_19
//
//  Created by Oleksandr Karpenko on 30.09.2020.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleNotification(identifier: "group.lesson_19", title: "title", subtitle: "subtitle", body: "body", timeInterval: 5)
    }

    func scheduleNotification(identifier: String, title: String, subtitle: String, body: String, timeInterval: TimeInterval, repeats: Bool = false) {
        let content = UNMutableNotificationContent()
        content.title = "popupText"
        content.body = "popupButton"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
       
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}
