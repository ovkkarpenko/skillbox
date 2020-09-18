//
//  User.swift
//  lesson_11
//
//  Created by Oleksandr Karpenko on 18.09.2020.
//

import Foundation

struct User {
    
    var email: String?
    var password: String?
    
    func validate() -> Bool {
        return isValidEmail() && isValidPassword()
    }
    
    private func isValidEmail() -> Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
    private func isValidPassword() -> Bool {
        let regEx = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{6,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: password)
    }
    
}
