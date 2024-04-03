//
//  OctetCounterTest.swift
//  xxdTest
//
//  Created by Matthew Axsom on 4/2/24.
//

import XCTest

final class OctetCounterTest : XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testOctetCounter() throws {
        var theCounter = OctetCounter(max: OctetCounter.kNoLength)
        XCTAssertEqual(theCounter.octetsToRead(), OctetCounter.kDefaultOctetCount)
        
        theCounter = OctetCounter(max: 10)
        XCTAssertEqual(theCounter.octetsToRead(), 10)
        
        theCounter = OctetCounter(max: 30)
        XCTAssertEqual(theCounter.octetsToRead(), OctetCounter.kDefaultOctetCount)
        theCounter.incrementOctetsRead(by: OctetCounter.kDefaultOctetCount)
        XCTAssertEqual(theCounter.octetsToRead(), 14)
        theCounter.incrementOctetsRead(by: 14)
        XCTAssertEqual(theCounter.octetsToRead(), 0)
        
        // test beyond end
        theCounter.incrementOctetsRead(by: 32)
        XCTAssertEqual(theCounter.octetsToRead(), 0)
    }
}

