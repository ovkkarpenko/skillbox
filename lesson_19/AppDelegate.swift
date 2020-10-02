//
//  AppDelegate.swift
//  lesson_19
//
//  Created by Oleksandr Karpenko on 30.09.2020.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupFirebase()
        return true
    }
    
    private func setupFirebase() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        registerForPushNotifications { granted in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func registerForPushNotifications(completion: ((Bool) -> Void)? = nil) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options: authOptions, completionHandler: { granted, _ in
            completion?(granted)
        })
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if notification.request.identifier == "group.lesson_19" {
            let alert = UIAlertController(title: "Alert", message: notification.request.content.title, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: notification.request.content.body, style: .default, handler: nil))
            
            if let vc = UIApplication.shared.keyWindow?.rootViewController as? ViewController {
                vc.present(alert, animated: true)
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        if let popupText = remoteMessage.appData["popupText"] as? String,
           let popupButton = remoteMessage.appData["popupButton"] as? String{
            let alert = UIAlertController(title: "Alert", message: popupText, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: popupButton, style: .default, handler: nil))
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.present(alert, animated: true)
        }
    }
    
}
