//
//  lesson_11UITests.swift
//  lesson_11UITests
//
//  Created by Oleksandr Karpenko on 18.09.2020.
//

import XCTest

class lesson_11UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidUserWithPasswordWithoutUpperRegister() throws {
        let app = XCUIApplication()
        app.launch()
        
        //given
        let email = "qwerty@ru.ru"
        let password = "qwerty123"
        
        //when
        let emailTextField = app.textFields["EmailTextfield"]
        let passwordTextField = app.textFields["PasswordTextfield"]
        let loginButton = app.buttons["LoginButton"]
        let resultMessageLabel = app.staticTexts["ResultMessageLabel"]
        
        emailTextField.tap()
        emailTextField.typeText(email)
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        
        loginButton.tap()
        
        //then
        XCTAssertTrue(resultMessageLabel.exists)
    }
    
    func testValidUserWithPasswordWithoutLowerRegister() throws {
        let app = XCUIApplication()
        app.launch()
        
        //given
        let email = "qwerty@ru.ru"
        let password = "QWERTY123"
        
        //when
        let emailTextField = app.textFields["EmailTextfield"]
        let passwordTextField = app.textFields["PasswordTextfield"]
        let loginButton = app.buttons["LoginButton"]
        let resultMessageLabel = app.staticTexts["ResultMessageLabel"]
        
        emailTextField.tap()
        emailTextField.typeText(email)
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        
        loginButton.tap()
        
        //then
        XCTAssertTrue(resultMessageLabel.exists)
    }
    
    func testValidUserWithBadEmail() throws {
        let app = XCUIApplication()
        app.launch()
        
        //given
        let email = "@ru.ru"
        let password = "qwertY123"
        
        //when
        let emailTextField = app.textFields["EmailTextfield"]
        let passwordTextField = app.textFields["PasswordTextfield"]
        let loginButton = app.buttons["LoginButton"]
        let resultMessageLabel = app.staticTexts["ResultMessageLabel"]
        
        emailTextField.tap()
        emailTextField.typeText(email)
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        
        loginButton.tap()
        
        //then
        XCTAssertTrue(resultMessageLabel.exists)
    }
    
    func testValidUser() throws {
        let app = XCUIApplication()
        app.launch()
        
        //given
        let email = "qwerty@ru.ru"
        let password = "qwertY123"
        
        //when
        let emailTextField = app.textFields["EmailTextfield"]
        let passwordTextField = app.textFields["PasswordTextfield"]
        let loginButton = app.buttons["LoginButton"]
        let resultMessageLabel = app.staticTexts["ResultMessageLabel"]
        
        emailTextField.tap()
        emailTextField.typeText(email)
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        
        loginButton.tap()
        
        //then
        XCTAssertFalse(resultMessageLabel.exists)
    }
}
