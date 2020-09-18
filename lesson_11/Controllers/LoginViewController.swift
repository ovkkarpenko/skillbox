//
//  ViewController.swift
//  lesson_11
//
//  Created by Oleksandr Karpenko on 18.09.2020.
//

import UIKit
import Bond
import ReactiveKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var resultMessageLabel: UILabel!
    
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        combineLatest(emailTextfield.reactive.text, passwordTextField.reactive.text) { email, password in
            guard let email = email,
                  let password = password else { return false }
            
            self.user.email = email
            self.user.password = password
            
            return email.count > 0 && password.count > 0
        }.bind(to: loginButton.reactive.isEnabled)
        
        let _ = loginButton.reactive.controlEvents(.touchUpInside)
            .observeNext { e in
                let result = self.user.validate()
                if result {
                    self.performSegue(withIdentifier: "LoginSuccess", sender: nil)
                }
                
                self.resultMessageLabel.isHidden = result
            }
    }
    
}

