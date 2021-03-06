//
//  BitcoinRateUITests.swift
//  BitcoinRateUITests
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import XCTest

class BitcoinRateUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        app.launchEnvironment["-ShouldMockResponse"] = "YES"
        
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCurrentRateDisplay() {
        let app = XCUIApplication()
        let text = app.staticTexts["Today's Rate: 7688.89 €"]
        XCTAssertEqual(text.label, "Today's Rate: 7688.89 €")
    }
}
