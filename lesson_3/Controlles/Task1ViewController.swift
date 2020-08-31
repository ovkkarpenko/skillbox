//
//  ViewController.swift
//  lesson_3
//
//  Created by Oleksandr Karpenko on 30.08.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit
import Bond

class Task1ViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userMessageLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.reactive.text.observeNext(with: { _ in
            self.validateParams()
        }).dispose(in: reactive.bag)
        
        passwordTextField.reactive.text.observeNext(with: { _ in
            self.validateParams()
        }).dispose(in: reactive.bag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reactive.bag.dispose()
    }
    
    func validateParams() {
        guard let login = loginTextField.text,
            let password = passwordTextField.text else { return }
        
        if !isValidEmail(login) {
            userMessageLabel.text = "Incorrect login"
            sendButton.isEnabled = false
        } else if password.count < 6 {
            userMessageLabel.text = "Password length should be more than 6 charsets"
            sendButton.isEnabled = false
        } else {
            userMessageLabel.text = ""
            sendButton.isEnabled = true
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}

