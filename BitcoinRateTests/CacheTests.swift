//
//  CacheTests.swift
//  BitcoinRateTests
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import XCTest
@testable import BitcoinRate

fileprivate struct TestObject: Codable {
    var title: String
    var number: Int
}

class CacheTests: XCTestCase {
    
    let cache = Cache()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        cache.clearCache()
    }

    func testSaveAndLoadCache() {
        
        let router = Router.currentRate
        let obj = TestObject(title: "Test string", number: 42)
        cache.save(obj, for: router)
        
        let savedObj: TestObject? = cache.load(router)
        XCTAssertNotNil(savedObj)
        XCTAssertEqual(savedObj!.title, "Test string")
        XCTAssertEqual(savedObj!.number, 42)
    }
    
    func testNilObject() {
        let cache = Cache()
        
        let router = Router.currentRate
        
        let savedObj: TestObject? = cache.load(router)
        XCTAssertNil(savedObj)
    }
    
    func testClearAllObjects() {
        let cache = Cache()
        
        let router = Router.currentRate
        let obj = TestObject(title: "Test string", number: 42)
        cache.save(obj, for: router)
        cache.clearCache()
    
        let savedObj: TestObject? = cache.load(router)
        XCTAssertNil(savedObj)
    }
}
