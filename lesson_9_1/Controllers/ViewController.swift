//
//  ViewController.swift
//  lesson_9_1
//
//  Created by Oleksandr Karpenko on 16.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookShare
import VK_ios_sdk
import GoogleSignIn

class ViewController: UIViewController {
    
    @IBOutlet weak var loginFB: FBLoginButton!
    @IBOutlet weak var loginVK: UIButton!
    @IBOutlet weak var shareLinkFB: FBShareButton!
    @IBOutlet weak var shareLinkVK: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loginFB.delegate = self
        loginFB.permissions.append("email")
        
        let content = ShareLinkContent()
        content.contentURL = URL(string: "http://google.com/")!
        content.hashtag = Hashtag("#bestSharingSampleEver")
        shareLinkFB.shareContent = content
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        if let token = AccessToken.current, !token.isExpired {
            shareLinkFB.isHidden = false
        }
        
        VKSdk.wakeUpSession(["email"], complete: { (state: VKAuthorizationState, error: Error?) in
            if state == .authorized {
                self.loginVK.setTitle("Log out", for: .normal)
                self.shareLinkVK.isHidden = false
            }
        })
    }
    
    
    @IBAction func loginVKButton(_ sender: Any) {
        if loginVK.title(for: .normal) == "Login VK" {
            VKSdk.authorize(["email"])
            self.loginVK.setTitle("Log out", for: .normal)
        } else {
            VKSdk.forceLogout()
            self.loginVK.setTitle("Login VK", for: .normal)
        }
    }
    
    @IBAction func shareLinkVK(_ sender: Any) {
        let shareDialog = VKShareDialogController()
        shareDialog.text = "bestSharingSampleEver"
        shareDialog.shareLink = VKShareLink(title: "google.com", link: URL(string: "http://google.com/")!)
        shareDialog.completionHandler = { (dialog, result) in
            self.dismiss(animated: true, completion: nil)
        }
        
        present(shareDialog, animated: true, completion: nil)
    }
    
}

extension ViewController: LoginButtonDelegate, SharingDelegate, VKSdkDelegate {
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        
    }
    
    func vkSdkUserAuthorizationFailed() {
        
    }
    
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        
    }
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let result = result else {
            print("Login attempt failed")
            return
        }
        
        guard !result.isCancelled else {
            return print("Login attempt was cancelled")
        }
        
        shareLinkFB.isHidden = false
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        shareLinkFB.isHidden = true
    }
    
}
