//
//  BitcoinRateErrorUITests.swift
//  BitcoinRateUITests
//
//  Created by Nataniel Martin on 10/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import XCTest

class BitcoinRateErrorUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        app.launchEnvironment["-ShouldMockErrorResponse"] = "YES"
        
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCurrentRateDisplay() {
        let app = XCUIApplication()
        XCTAssert(app.alerts["Error"].exists)
    }
    
}
