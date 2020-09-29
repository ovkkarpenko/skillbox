//
//  QuickTests.swift
//  lesson_18Tests
//
//  Created by Oleksandr Karpenko on 28.09.2020.
//

import Foundation
import Quick
import Nimble
@testable import lesson_18

class QuickTests: QuickSpec {
    
    override func spec() {
        describe("MyArray") {
            let array = [-2, 0, 1, 4, 10, 3, -10]
            let myArray = MyArray(array: array)
            
            it("check if minimum number is correct") {
                expect(myArray.min()).to(equal(-10))
            }
            
            it("check if the maximum number is correct") {
                expect(myArray.max()).to(equal(10))
            }
            
            it("performs sort by abc correctly") {
                expect(myArray.sortByAbc()).to(equal([-10, -2, 0, 1, 3, 4, 10]))
            }
            
            it("performs sort by desc correctly") {
                expect(myArray.sortByDesc()).to(equal([10, 4, 3, 1, 0, -2, -10]))
            }
            
            it("performs join correctly") {
                expect(myArray.join()).to(equal("-2 0 1 4 10 3 -10"))
            }
        }
        
        describe("UserDB") {
            let userDB = UserDB.shared
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            
            it("performs adding new user") {
                let user1 = User(fullName: "Alex", height: 180, weight: 80, gender: .man, birthday: formatter.date(from: "15/04/1997")!)
                let user2 = User(fullName: "Tanya", height: 170, weight: 60, gender: .woman, birthday: formatter.date(from: "10/01/1998")!)
                let user3 = User(fullName: "Max", height: 160, weight: 60, gender: .man, birthday: formatter.date(from: "02/11/1996")!)
                
                userDB.add(user1.userToRealm())
                userDB.add(user2.userToRealm())
                userDB.add(user3.userToRealm())
                
                let users = userDB.getAll()
                expect(users.count).to(equal(3))
            }
            
            it("performs finding the youngest user correctly") {
                let user = userDB.findYoungestUser()
                expect(user == nil).to(beFalse())
                
                if let user = user {
                    expect(formatter.string(from: user.birthday)).to(equal("10/01/1998"))
                }
            }
            
            it("performs finding the oldest user correctly") {
                let user = userDB.findOldestUser()
                expect(user == nil).to(beFalse())
                
                if let user = user {
                    expect(formatter.string(from: user.birthday)).to(equal("02/11/1996"))
                }
            }
            
            it("performs removing users") {
                var users = userDB.getAll()
                
                users.forEach { user in
                    userDB.remove(user)
                }
                
                users = userDB.getAll()
                
                expect(users.count).to(equal(0))
            }
        }
    }
    
}
