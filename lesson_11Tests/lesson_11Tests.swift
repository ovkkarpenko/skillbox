//
//  lesson_11Tests.swift
//  lesson_11Tests
//
//  Created by Oleksandr Karpenko on 18.09.2020.
//

import XCTest
@testable import lesson_11

class lesson_11Tests: XCTestCase {
    
    func testValidUser() throws {
        //given
        let user1 = User(email: "qwerty@ru.ry", password: "qwertYYYYY")
        let user2 = User(email: "qwerty@ru.ry", password: "qwerty123")
        let user3 = User(email: "qwerty@ru.ry", password: "QWERTY123")
        let user4 = User(email: "qwerty@ru.ry", password: "!!!!!!!!!")
        let user5 = User(email: "qwerty@qwe", password: "qwertY123")
        let user6 = User(email: "a@a", password: "qwertY123")
        let user7 = User(email: "@ru.ry", password: "qwertY123")
        let user8 = User(email: "qwerty@.", password: "qwertY123")
        let user9 = User(email: "qwerty@.ru.ru", password: "qwertY123")
        
        //when
        let result1 = user1.validate()
        let result2 = user2.validate()
        let result3 = user3.validate()
        let result4 = user4.validate()
        let result5 = user5.validate()
        let result6 = user6.validate()
        let result7 = user7.validate()
        let result8 = user8.validate()
        let result9 = user9.validate()
        
        //then
        XCTAssertFalse(result1)
        XCTAssertFalse(result2)
        XCTAssertFalse(result3)
        XCTAssertFalse(result4)
        XCTAssertFalse(result5)
        XCTAssertFalse(result6)
        XCTAssertFalse(result7)
        XCTAssertFalse(result8)
        XCTAssertTrue(result9)
    }

}
