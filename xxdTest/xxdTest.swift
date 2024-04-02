//
//  xxdTest.swift
//  xxdTest
//
//  Created by Matthew Axsom on 3/31/24.
//

import XCTest

final class xxdTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        var greeting = Greeting()
        XCTAssertNotNil(greeting.name)
        
        greeting.name = "Matthew"
        XCTAssertTrue(greeting.name == "Matthew")
    }
}
