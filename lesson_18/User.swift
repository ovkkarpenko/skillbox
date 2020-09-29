//
//  User.swift
//  lesson_18
//
//  Created by Oleksandr Karpenko on 28.09.2020.
//

import Foundation

enum Gender: String {
    case none
    case man
    case woman
}

struct User {
    
    var id: Int?
    var fullName: String
    var height: Int
    var weight: Int
    var gender: Gender
    var birthday: Date
    
    func userToRealm() -> UserRealm {
        let user = UserRealm()
        user.id = id ?? 0
        user.fullName = fullName
        user.height = height
        user.weight = weight
        user.gender = gender.rawValue
        user.birthday = birthday
        
        return user
    }
}
