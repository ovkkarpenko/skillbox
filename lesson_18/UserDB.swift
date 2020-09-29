//
//  UserDB.swift
//  lesson_18
//
//  Created by Oleksandr Karpenko on 28.09.2020.
//

import Foundation
import RealmSwift

class UserDB {
    
    static let shared = UserDB()
    
    private let realm = try! Realm()
    private var users: [UserRealm] = []
    
    private init() {
        users = getAll()
    }
    
    func add(_ user: UserRealm) {
        let newUser = user
        newUser.id = users.count
        
        try! realm.write {
            users.append(newUser)
            realm.add(newUser)
        }
    }
    
    func remove(_ user: UserRealm) {
        let userRemove = realm.objects(UserRealm.self).filter("id=%@", user.id)
        
        try! realm.write {
            realm.delete(userRemove)
        }
    }
    
    func findYoungestUser() -> UserRealm? {
        if users.count == 0 { return nil }
        return users.min(by: { user1, user2 in
            return user1.birthday > user2.birthday
        })
    }
    
    func findOldestUser() -> UserRealm? {
        if users.count == 0 { return nil }
        return users.max(by: { user1, user2 in
            return user1.birthday > user2.birthday
        })
    }
    
    func getAll() -> [UserRealm] {
        return realm.objects(UserRealm.self).map {
            let user = UserRealm()
            user.id = $0.id
            user.fullName = $0.fullName
            user.height = $0.height
            user.weight = $0.weight
            user.gender = $0.gender
            user.birthday = $0.birthday
            
            return user
        }
    }
    
}
