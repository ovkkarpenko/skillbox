//
//  UserRealm.swift
//  lesson_18
//
//  Created by Oleksandr Karpenko on 28.09.2020.
//

import Foundation
import RealmSwift

class UserRealm: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var fullName = ""
    @objc dynamic var height = 0
    @objc dynamic var weight = 0
    @objc dynamic var gender = Gender.none.rawValue
    @objc dynamic var birthday: Date = Date.init()
    
}
