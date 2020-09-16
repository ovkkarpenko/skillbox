//
//  AppDelegate.swift
//  lesson_9_1
//
//  Created by Oleksandr Karpenko on 16.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import VK_ios_sdk
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
        VKSdk.initialize(withAppId: "6376646")?.uiDelegate = self
        
        GIDSignIn.sharedInstance().clientID = "403391173226-c1m3kbigdlucknn2esrgrbg1diaspvrq.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        return true
    }
    
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
        
        GIDSignIn.sharedInstance().handle(url)
        
        return ApplicationDelegate.shared.application(app, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
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

extension AppDelegate: VKSdkUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
          print("The user has not signed in before or they have since signed out.")
        } else {
          print("\(error.localizedDescription)")
        }
        // [START_EXCLUDE silent]
        NotificationCenter.default.post(
          name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
        // [END_EXCLUDE]
        return
      }
      // Perform any operations on signed in user here.
      let userId = user.userID                  // For client-side use only!
      let idToken = user.authentication.idToken // Safe to send to the server
      let fullName = user.profile.name
      let givenName = user.profile.givenName
      let familyName = user.profile.familyName
      let email = user.profile.email
      // [START_EXCLUDE]
      NotificationCenter.default.post(
        name: Notification.Name(rawValue: "ToggleAuthUINotification"),
        object: nil,
        userInfo: ["statusText": "Signed in user:\n\(fullName!)"])
      // [END_EXCLUDE]
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // [START_EXCLUDE]
      NotificationCenter.default.post(
        name: Notification.Name(rawValue: "ToggleAuthUINotification"),
        object: nil,
        userInfo: ["statusText": "User has disconnected."])
      // [END_EXCLUDE]
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        let vc = UIApplication.shared.keyWindow?.rootViewController
        
        if vc?.presentedViewController != nil {
            vc?.dismiss(animated: true, completion: {
                vc?.present(controller, animated: true, completion: nil)
            })
        } else {
            vc?.present(controller, animated: true, completion: nil)
        }
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
    }
    
}
