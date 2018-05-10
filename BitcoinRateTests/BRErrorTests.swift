//
//  BRErrorTests.swift
//  BitcoinRateTests
//
//  Created by Nataniel Martin on 10/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import XCTest
@testable import BitcoinRate

class BRErrorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testInitMessage() {
        let error = BRError.message(title: "Test title", message: "This a test message")
        XCTAssertEqual(error.title, "Test title")
        XCTAssertEqual(error.message, "This a test message")
        XCTAssertEqual(error.description, "❌ Error : Test title - This a test message")
    }
    
    func testInitError() {
        let basicError = NSError(domain: "Test.Domain", code: 404, userInfo: [:])
        let error = BRError.error(basicError)
        XCTAssertEqual(error.title, "Error")
        XCTAssertEqual(error.message, "An error has occured")
    }
}
