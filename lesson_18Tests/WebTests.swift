//
//  WebTests.swift
//  lesson_18Tests
//
//  Created by Oleksandr Karpenko on 29.09.2020.
//

import Foundation
import Quick
import Nimble
import OHHTTPStubs
@testable import lesson_18

class WebTests: QuickSpec {
    
    let interactor = WeatherInteractor()
    
    override class func tearDown() {
        HTTPStubs.removeAllStubs()
    }
    
    override func spec() {
        stub(condition: isPath(interactor.relativeURL)) { _ in
            guard let path = OHPathForFile("Weather.json", type(of: self)) else {
                preconditionFailure("Could not find expected file in test bundle")
            }
            return HTTPStubsResponse(
                fileAtPath: path,
                statusCode: 200,
                headers: ["Content-Type": "application/json"])
        }
        
        let e = expectation(description: "Weather")
        
        interactor.interact { _ in
            let weather = self.interactor.weather
            
            describe("Weather") {
                it("parses") {
                    expect(weather == nil).to(beFalse())
                    
                    if let weather = weather {
                        expect(weather.cod).to(equal("200"))
                        expect(weather.eightDays.count).to(equal(8))
                    }
                }
            }
            e.fulfill()
        }
        
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
}
